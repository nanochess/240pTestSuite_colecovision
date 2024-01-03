/*
** Pletter v0.5c1
**
** XL2S Entertainment
**
** Copyright (c) 2002-2003 Team Bomba
**
** Permission is hereby granted, free of charge, to any person obtaining a copy of
** this software and associated documentation files (the "Software"), to deal in the
** Software without restriction, including without limitation the rights to use,
** copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
** Software, and to permit persons to whom the Software is furnished to do so, subject
** to the following conditions:
**
** The above copyright notice and this permission notice shall be included in all
** copies or substantial portions of the Software.
**
** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
** INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
** PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
** HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
** CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
** OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
**
** This is a LZ77-type compressor. The bit compression can be slow
** in comparison to RLE (more when decompressing directly to VRAM
** because it has to read the VRAM), but the space saving is amazing!
**
** Revision: 19-abr-2011. C conversion by Oscar Toledo G.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void addevent(void);
void claimevent(void);

unsigned char *d;

/*
** Offset m‡ximo para cada modo
*/
unsigned int maxlen[7] = {
  128,
  128 + 128,
  512 + 128,
  1024 + 128,
  2048 + 128,
  4096 + 128,
  8192 + 128
};

/*
** Costo de codificar una constante
*/
unsigned int varcost[65536];

/*
** Metadato por bytes
*/
struct metadata {
  unsigned int reeks;           /* Nœmero de veces que se repite el byte */
  unsigned int cpos[7];
  unsigned int clen[7];
} *m;

/*
** Compresi—n por byte para cada modo
*/
struct pakdata {
  unsigned int cost;
  unsigned int mode;
  unsigned int mlen;
} *p[7];

char sourcefilename[MAX_PATH];
char destfilename[MAX_PATH];

int savelength;
unsigned int tam_origen;
unsigned int offset;

struct saves {
  unsigned char *buf;
  int ep, dp, p, e;
} s;

/*
** Inicia buffer de salida
*/
void init(void)
{
  s.ep = s.dp = s.p = s.e = 0;
  s.buf = malloc(tam_origen * 2);
}

/*
** Agrega un bit cero a la salida
*/
void add0(void)
{
  if (s.p == 0)
    claimevent();
  s.e *= 2;
  ++s.p;
  if (s.p == 8)
    addevent();
}

/*
** Agrega un bit uno a la salida
*/
void add1(void)
{
  if (s.p == 0)
    claimevent();
  s.e *= 2;
  ++s.p;
  ++s.e;
  if (s.p == 8)
    addevent();
}

/*
** Agrega un bit X a la salida
*/
void addbit(int b)
{
  if (b)
    add1();
  else
    add0();
}

/*
** Agrega tres bits a la salida
*/
void add3(int b)
{
  addbit(b & 4);
  addbit(b & 2);
  addbit(b & 1);
}

/*
** Agrega un nœmero variable a la salida
*/
void addvar(int i)
{
  int j = 0x8000;

  /*
  ** Busca el primer bit a uno
  */
  while ((i & j) == 0)
    j >>= 1;
    
  /*
  ** Como en punto flotante, el descompactador anexa un uno extra
  */
  while (j != 1) {
    j >>= 1;
    add1();
    if ((i & j) != 0)
      add1();
    else
      add0();
  }
  add0();  /* Se–al de final */
}

/*
** Agrega un dato a la salida
*/
void adddata(unsigned char d)
{
  s.buf[s.dp++] = d;
}

/*
** Vac’a el buffer de bits
*/
void addevent(void)
{
  s.buf[s.ep] = s.e;
  s.e = s.p = 0;
}

/*
** Anota donde va a guardar los pr—ximos 8 bits
*/
void claimevent(void)
{
  s.ep = s.dp;
  ++s.dp;
}

/*
** Rellena a ceros y guardar el archivo final
*/
void done(void)
{
  FILE *file;

  if (s.p != 0) {
    while (s.p != 8) {
      s.e *= 2;
      s.p++;
    }
    addevent();
  }
  if (!(file = fopen(destfilename, "wb"))) {
    printf("Error writing file!\n");
    exit(1);
  }
  fwrite(s.buf, 1, s.dp, file);
  fclose(file);
  free(s.buf);
  printf(" %s: %d -> %d\n", destfilename, tam_origen, s.dp);
}

/*
** Carga el archivo origen
*/
void loadfile(char *sourcefilename)
{
  FILE *file;

  if ((file = fopen(sourcefilename, "rb")) == NULL) {
    printf("Error opening file: %s\n", sourcefilename);
    exit(1);
  }
  if (!tam_origen) {
    fseek(file, 0, SEEK_END);
    tam_origen = ftell(file) - offset;
  }
  fseek(file, offset, SEEK_SET);
  d = malloc(tam_origen + 1);
  m = malloc(sizeof(struct metadata) * (tam_origen + 1));
  if (!fread(d, tam_origen, 1, file)) {
    printf("Filesize error");
    exit(1);
  }
  d[tam_origen] = 0;
  fclose(file);
}

/*
** Anota el costo de usar un nœmero variable
*/
void initvarcost(void)
{
  int v = 1;
  int b = 1;
  int r = 1;
  int j;

  /*
  ** Representar el 1 cuesta un bit  (0)
  ** 2-3 cuesta tres bits            (1x0)
  ** 4-7 cuesta cinco bits.          (1x1x0)
  */
  while (r != 65536) {
    for (j = 0; j != r; ++j)
      varcost[v++] = b;
    b += 2;
    r *= 2;
  }
}

/*
** Precompacta el archivo origen
*/
void createmetadata(void)
{
  unsigned int i;
  unsigned int j;
  unsigned int *last = malloc(65536 * sizeof(unsigned int));
  unsigned int *prev = malloc((tam_origen + 1) * sizeof(unsigned int));
  unsigned int r;
  unsigned int t;
  int bl;

  /*
  ** Para acelerar la bœsqueda de cadenas concordantes
  **
  ** Conforme avanza, prev[byte] apunta a la cadena inmediatamente previa
  ** que empieza con los mismos dos bytes actuales, no tiene caso ligar
  ** por bytes individuales porque el offset ocupa m’nimo un byte.
  **
  ** last es una especie de tabla de dispersi—n indicando donde se halla
  ** cada cadena de dos bytes encontrada.
  */
  memset(last, -1, 65536 * sizeof(unsigned int));
  for (i = 0; i != tam_origen; ++i) {
    m[i].cpos[0] = m[i].clen[0] = 0;
    prev[i] = last[d[i] + d[i + 1] * 256];
    last[d[i] + d[i + 1] * 256] = i;
  }

  /*
  ** Cuenta los bytes repetidos a partir de cada posici—n del origen
  */
  r = -1;
  t = 0;
  for (i = tam_origen - 1; i != -1; --i) {
    if (d[i] == r)
      m[i].reeks = ++t;
    else {
      r = d[i];
      m[i].reeks = t = 1;
    }
  }

  /*
  ** Ahora por cada modo posible
  */
  for (bl = 0; bl != 7; ++bl) {

    /*
    ** Procesa el archivo de entrada
    */
    for (i = 0; i < tam_origen; ++i) {
      unsigned int l;
      unsigned int p;

      p = i;
      if (bl) {
        m[i].clen[bl] = m[i].clen[bl - 1];
        m[i].cpos[bl] = m[i].cpos[bl - 1];
        p = i - m[i].cpos[bl];
      }
      
      /*
      ** Por cada cadena repetida
      */
      while ((p = prev[p]) != -1) {
        if (i - p > maxlen[bl])  /* ÀExcede el offset posible? */
          break;                 /* S’, termina */
        l = 0;
        while (d[p + l] == d[i + l] && (i + l) < tam_origen) {

          /*
          ** Truco de aceleraci—n:
          **   Si la cadena que se quiere substituir tiene bytes repetidos...
          **   y la cadena que se usar‡ como reemplazo tiene menos bytes
          **   repetidos...
          **   entonces puede tomar solamente los que hay y adem‡s se
          **   evita el cl‡sico problema o(n2)
          */
          if (m[i + l].reeks > 1) {
            if ((j = m[i + l].reeks) > m[p + l].reeks)
              j = m[p + l].reeks;
            l += j;
          } else
            ++l;
        }
        if (l > m[i].clen[bl]) {  /* Busca la cadena m‡s larga */
          m[i].clen[bl] = l;      /* Longitud */
          m[i].cpos[bl] = i - p;  /* Posici—n (offset) */
        }
      }
    }
    putchar('.');
  }
  putchar(' ');
  free(prev);
  free(last);
}

/*
** Obtiene el tama–o final del archivo con un modo
*/
int getlen(struct pakdata *p, unsigned int modo)
{
  unsigned int i;
  unsigned int j;
  unsigned int cc;
  unsigned int ccc;
  unsigned int kc;
  unsigned int kmode;
  unsigned int kl;

  p[tam_origen].cost = 0;
  
  /*
  ** Truco, marcha de adelante para atr‡s, as’ puede conocer todas las
  ** combinaciones posibles de compactaci—n.
  */
  for (i = tam_origen - 1; i != -1; --i) {
    kmode = 0;  /* Literal */
    kl = 0;
    kc = 9 + p[i + 1].cost;
    
    /* Prueba todos los tama–os hasta hallar el m‡s corto */
    j = m[i].clen[0];
    while (j > 1) {
      cc = 9 + varcost[j - 1] + p[i + j].cost;
      if (cc < kc) {
        kc = cc;
        kmode = 1;  /* Offset corto */
        kl = j;
      }
      --j;
    }
    
    /* Prueba todos los tamaños hasta hallar el m‡s corto */
    j = m[i].clen[modo];
    if (modo == 1)
      ccc = 9;
    else
      ccc = 9 + modo;
    while (j > 1) {
      cc = ccc + varcost[j - 1] + p[i + j].cost;
      if (cc < kc) {
        kc = cc;
        kmode = 2;  /* Offset largo */
        kl = j;
      }
      --j;
    }
    p[i].cost = kc;
    p[i].mode = kmode;
    p[i].mlen = kl;
  }
  return p[0].cost;
}

/*
** Genera el archivo compactado
*/
void save(struct pakdata *p, unsigned int modo)
{
  unsigned int i;
  unsigned int j;

  init();
  if (savelength) {
    adddata(tam_origen & 255);
    adddata(tam_origen >> 8);
  }
  add3(modo - 1);
  adddata(d[0]);
  i = 1;
  while (i < tam_origen) {
    switch (p[i].mode) {
      case 0:  /* Literal */
        add0();
        adddata(d[i]);
        ++i;
        break;
      case 1:  /* Offset corto */
        add1();
        addvar(p[i].mlen - 1);
        j = m[i].cpos[0] - 1;
        if (j > 127)
          printf("-j>128-");
        adddata(j);
        i += p[i].mlen;
        break;
      case 2:  /* Offset largo */
        add1();
        addvar(p[i].mlen - 1);
        j = m[i].cpos[modo] - 1;
        if (j < 128)
          printf("-j<128-");
        adddata(128 | j & 127);
        j -= 128;
        switch (modo) {
          case 6:
            addbit(j & 4096);
          case 5:
            addbit(j & 2048);
          case 4:
            addbit(j & 1024);
          case 3:
            addbit(j & 512);
          case 2:
            addbit(j & 256);
            addbit(j & 128);
          case 1:
            break;
          default:
            printf("-2-");
            break;
        }
        i += p[i].mlen;
        break;
      default:
        printf("-?-");
        break;
    }
  }
  for (i = 0; i != 34; ++i)
    add1();
  done();
}

/*
** Programa principal
*/
int main(int argc, char *argv[])
{
  int i;
  int l;
  int minlen;
  int minbl;

  if (argc == 1) {
    printf("\nPletter v0.5c1 - www.xl2s.tk\n");
    printf("\nUsage:\npletter [-s[ave_length]] sourcefile [[offset [length]] [destinationfile]]\n");
    exit(0);
  }
  offset = 0;
  tam_origen = 0;
  i = 1;
  if (argv[i][0] == '-') {
    savelength = (argv[i][1] == 's') || (argv[i][1] == 'S');
    ++i;
  }
  if (argv[i])
    strncpy(sourcefilename, argv[i++], sizeof(sourcefilename) - 1);
  if (argv[i] && isdigit(argv[i][0])) {
    offset = atoi(argv[i++]);
    if (argv[i] && isdigit(argv[i][0]))
      tam_origen = atoi(argv[i++]);
  }
  if (argv[i])
    strncpy(destfilename, argv[i++], sizeof(destfilename) - 1);
  if (!sourcefilename[0]) {
    printf("No inputfile");
    exit(0);
  }
  if (!destfilename[0]) {
    strcpy(destfilename, sourcefilename);
    strcat(destfilename, ".plet5");
  }
  loadfile(sourcefilename);
  initvarcost();
  createmetadata();
  minlen = tam_origen * 1000;
  minbl = 0;
  for (i = 1; i != 7; ++i) {
    p[i] = malloc(sizeof(struct pakdata) * (tam_origen + 1));
    l = getlen(p[i], i);
    if (l < minlen && i) {
      minlen = l;
      minbl = i;
    }
    putchar('.');
  }
  save(p[minbl], minbl);
  for (i = 1; i != 7; ++i)
    free(p[i]);
  free(m);
  free(d);
  return 0;
}
