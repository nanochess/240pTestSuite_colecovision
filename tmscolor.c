/*
** Converts a BMP image to TMS9928 bitmap/color format
**
** by Oscar Toledo Gutiérrez
** http://nanochess.org/
**
** (c) Copyright 2009-2023 Oscar Toledo Gutiérrez
**
** Creación: 06-jun-2009.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <time.h>
#include <limits.h>
#include <math.h>

#define VERSION "2.0.4 Jan/09/2023"     /* Software version */

#define ROUND8(x)  ((x + 7) & ~7)

unsigned char *bitmap;
unsigned char *color;
unsigned char *pattern;
unsigned char *source;

unsigned char *source2;
unsigned char *ignore;
unsigned char usage[24][32][32];
unsigned char sprites[2048];
unsigned char attr[128];

int size_x;                     /* Size X in pixels */
int size_y;                     /* Size Y in pixels */

/*
 ** Use any of these palettes in your paint program
 */
unsigned char colors[16 * 3] = {
    0x40, 0x40, 0x40,
    0x00, 0x00, 0x00,
    0x20, 0xc2, 0x20,	/* 2 - Green */
    0x61, 0xe2, 0x61,	/* 3 - Light green */
    0xe2, 0x20, 0x20,	/* 4 - Blue */
    0xe2, 0x61, 0x40,	/* 5 - Light blue */
    0x20, 0x20, 0xa1,	/* 6 - Dark red */
    0xe2, 0xc2, 0x40,	/* 7 - Cyan */
    0x20, 0x20, 0xe2,	/* 8 - Red */
    0x64, 0x62, 0xe4,	/* 9 - Light red */
    0x20, 0xc2, 0xc2,	/* 10 - Yellow */
    0x81, 0xc2, 0xc2,	/* 11 - Light yellow */
    0x20, 0x81, 0x20,	/* 12 - Dark green */
    0xe2, 0x20, 0xc2,
    0xa1, 0xa1, 0xa1,	/* 14 - Gray */
    0xe2, 0xe2, 0xe2,	/* 15 - White */
};

unsigned char colors_ntsc[16 * 3] = {
    0x40, 0x40, 0x40,
    0x00, 0x00, 0x00,
    0x45, 0xc5, 0x25,	/* 2 - Green */
    0x7a, 0xda, 0x62,	/* 3 - Light green */
    0xe8, 0x57, 0x55,	/* 4 - Blue */
    0xf8, 0x77, 0x7d,	/* 5 - Light blue */
    0x4e, 0x53, 0xd0,	/* 6 - Dark red */
    0xf2, 0xea, 0x47,	/* 7 - Cyan */
    0x56, 0x57, 0xf8,	/* 8 - Red */
    0x7a, 0x7b, 0xff,	/* 9 - Light red */
    0x58, 0xc0, 0xd3,	/* 10 - Yellow */
    0x83, 0xcd, 0xe5,	/* 11 - Light yellow */
    0x3d, 0xad, 0x25,	/* 12 - Dark green */
    0xb8, 0x5d, 0xc7,
    0xcc, 0xcc, 0xcc,	/* 14 - Gray */
    0xff, 0xff, 0xff,	/* 15 - White */
};


unsigned char colors_pal[16 * 3] = {
    0x40, 0x40, 0x40,
    0x00, 0x00, 0x00,
    0x57, 0xd7, 0x37,	/* 2 - Green */
    0x89, 0xe9, 0x71,	/* 3 - Light green */
    0xfa, 0x69, 0x67,	/* 4 - Blue */
    0xff, 0x89, 0x8f,	/* 5 - Light blue */
    0x6f, 0x56, 0xf0,	/* 6 - Dark red */
    0xf2, 0xea, 0x47,	/* 7 - Cyan */
    0x81, 0x68, 0xff,	/* 8 - Red */
    0xa2, 0x89, 0xff,	/* 9 - Light red */
    0x58, 0xcc, 0xdd,	/* 10 - Yellow */
    0x68, 0xdc, 0xed,	/* 11 - Light yellow */
    0x4c, 0xbc, 0x34,	/* 12 - Dark green */
    0xca, 0x6f, 0xd9,
    0xcc, 0xcc, 0xcc,	/* 14 - Gray */
    0xff, 0xff, 0xff,	/* 15 - White */
};

/*
 ** Converts from hexadecimal
 */
int from_hex(int letter)
{
    letter = toupper(letter);
    if (letter < '0')
        return 0;
    if (letter > 'F')
        return 15;
    letter -= '0';
    if (letter > 9)
        letter -= 7;
    return letter;
}

/*
** Prototypes
*/
int main(int, char *[]);

int check_triple_color(void)
{
    int c;
    int d;
    int y;
    int x;
    int g;
    int b;
    int color2;
    int color3;
    int triple_color;
    
    memset(&usage[0][0][0], 255, sizeof(usage));
    memset(ignore, 0, size_x * size_y);
    //
    // Find the color usage per 8x8 block
    //
    triple_color = 0;
    for (c = 0; c < 24; c++) {
        for (d = 0; d < 32; d++) {
            for (y = c * 8; y < (c + 1) * 8; y++) {
                color2 = 255;
                color3 = 255;
                g = 255;
                for (x = d * 8; x < (d + 1) * 8; x++) {
                    if (color2 == source[y * size_x + x])
                        ;
                    else if (color3 == source[y * size_x + x])
                        ;
                    else if (color2 == 255)
                        color2 = source[y * size_x + x];
                    else if (color3 == 255)
                        color3 = source[y * size_x + x];
                    else {
                        if (g == 255)
                            triple_color++;
                        g = source[y * size_x + x];
                        for (b = 0; b < 16; b++) {
                            if (usage[c][d][b] == color2)
                                break;
                            if (usage[c][d][b] == 255)
                                break;
                        }
                        if (usage[c][d][b] == 255) {
                            usage[c][d][b] = color2;
                            usage[c][d][color2 + 16] = 0;
                        }
                        for (b = 0; b < 16; b++) {
                            if (usage[c][d][b] == color3)
                                break;
                            if (usage[c][d][b] == 255)
                                break;
                        }
                        if (usage[c][d][b] == 255) {
                            usage[c][d][b] = color3;
                            usage[c][d][color3 + 16] = 0;
                        }
                        for (b = 0; b < 16; b++) {
                            if (usage[c][d][b] == source[y * size_x + x])
                                break;
                            if (usage[c][d][b] == 255)
                                break;
                        }
                        if (usage[c][d][b] == 255) {
                            usage[c][d][b] = source[y * size_x + x];
                            usage[c][d][source[y * size_x + x] + 16] = 0;
                        }
                    }
                }
                if (g == 255) {
                    for (x = d * 8; x < (d + 1) * 8; x++)
                        ignore[y * size_x + x] = 1;
                }
            }
        }
    }
    return triple_color;
}

#define sqr(c)  ((c) * (c))

typedef struct {
    double a;
    double b;
    double l;
} LAB;

/*
 ** Converted from Javascript code at https://github.com/antimatter15/rgb-lab
 ** MIT license Copyright (c) 2014 Kevin Kwok <antimatter15@gmail.com>
 ** Unfortunately the deltaE comparison function isn't so good as the CIEDE2000 function.
 */
void rgb2lab(unsigned char rgb[3], LAB *lab)
{
    double r = rgb[2] / 255.0;
    double g = rgb[1] / 255.0;
    double b = rgb[0] / 255.0;
    double x;
    double y;
    double z;
    
    r = (r > 0.04045) ? pow((r + 0.055) / 1.055, 2.4) : r / 12.92;
    g = (g > 0.04045) ? pow((g + 0.055) / 1.055, 2.4) : g / 12.92;
    b = (b > 0.04045) ? pow((b + 0.055) / 1.055, 2.4) : b / 12.92;
    
    x = (r * 0.4124 + g * 0.3576 + b * 0.1805) / 0.95047;
    y = (r * 0.2126 + g * 0.7152 + b * 0.0722) / 1.00000;
    z = (r * 0.0193 + g * 0.1192 + b * 0.9505) / 1.08883;
    
    x = (x > 0.008856) ? pow(x, 1.0/3) : (7.787 * x) + 16.0/116;
    y = (y > 0.008856) ? pow(y, 1.0/3) : (7.787 * y) + 16.0/116;
    z = (z > 0.008856) ? pow(z, 1.0/3) : (7.787 * z) + 16.0/116;
    
    lab->l = (116 * y) - 16;
    lab->a = 500 * (x - y);
    lab->b = 200 * (y - z);
}

double deltaE(LAB *a, LAB *b)
{
    double deltaL;
    double deltaA;
    double deltaB;
    double c1;
    double c2;
    double deltaC;
    double deltaH;
    double sc;
    double sh;
    double deltaLKlsl;
    double deltaCkcsc;
    double deltaHkhsh;
    double i;
    
    deltaL = a->l - b->l;
    deltaA = a->a - b->a;
    deltaB = a->b - b->b;
    c1 = sqrt(a->a * a->a + a->b * a->b);
    c2 = sqrt(b->a * b->a + b->b * b->b);
    deltaC = c1 - c2;
    deltaH = deltaA * deltaA + deltaB * deltaB - deltaC * deltaC;
    deltaH = deltaH < 0 ? 0 : sqrt(deltaH);
    sc = 1.0 + 0.045 * c1;
    sh = 1.0 + 0.015 * c1;
    deltaLKlsl = deltaL / (1.0);
    deltaCkcsc = deltaC / (sc);
    deltaHkhsh = deltaH / (sh);
    i = deltaLKlsl * deltaLKlsl + deltaCkcsc * deltaCkcsc + deltaHkhsh * deltaHkhsh;
    return i < 0 ? 0 : sqrt(i);
}

/*
 ** Converted from C++ code at https://github.com/gfiumara/CIEDE2000
 ** MIT license Copyright (c) 2015 Greg Fiumara
 */
#define M_PI 3.14159265358979

#define deg2Rad(deg)    ((deg) * (M_PI / 180.0))

#define rad2Deg(rad)    ((180.0 / M_PI) * (rad))

#define k_L 1.0
#define k_C 1.0
#define k_H 1.0
#define deg360InRad deg2Rad(360.0)
#define deg180InRad deg2Rad(180.0)
#define pow25To7    6103515625.0    /* pow(25, 7) */

double CIEDE2000(LAB *lab1, LAB *lab2)
{
    
    /*
     * Step 1
     */
    /* Equation 2 */
    double C1 = sqrt((lab1->a * lab1->a) + (lab1->b * lab1->b));
    double C2 = sqrt((lab2->a * lab2->a) + (lab2->b * lab2->b));
    /* Equation 3 */
    double barC = (C1 + C2) / 2.0;
    /* Equation 4 */
    double G = 0.5 * (1 - sqrt(pow(barC, 7) / (pow(barC, 7) + pow25To7)));
    /* Equation 5 */
    double a1Prime = (1.0 + G) * lab1->a;
    double a2Prime = (1.0 + G) * lab2->a;
    /* Equation 6 */
    double CPrime1 = sqrt((a1Prime * a1Prime) + (lab1->b * lab1->b));
    double CPrime2 = sqrt((a2Prime * a2Prime) + (lab2->b * lab2->b));
    /* Equation 7 */
    double hPrime1;
    double hPrime2;
    double deltaLPrime;
    double deltaCPrime;
    double deltahPrime;
    double CPrimeProduct;
    double deltaHPrime;
    double barLPrime;
    double barCPrime;
    double barhPrime;
    double hPrimeSum;
    double T;
    double deltaTheta;
    double R_C;
    double S_L;
    double S_C;
    double S_H;
    double R_T;
    double deltaE;
    
    if (lab1->b == 0 && a1Prime == 0)
        hPrime1 = 0.0;
    else {
        hPrime1 = atan2(lab1->b, a1Prime);
        if (hPrime1 < 0)
            hPrime1 += deg360InRad;
    }
    if (lab2->b == 0 && a2Prime == 0)
        hPrime2 = 0.0;
    else {
        hPrime2 = atan2(lab2->b, a2Prime);
        if (hPrime2 < 0)
            hPrime2 += deg360InRad;
    }
    
    /*
     * Step 2
     */
    /* Equation 8 */
    deltaLPrime = lab2->l - lab1->l;
    /* Equation 9 */
    deltaCPrime = CPrime2 - CPrime1;
    /* Equation 10 */
    
    CPrimeProduct = CPrime1 * CPrime2;
    if (CPrimeProduct == 0)
        deltahPrime = 0;
    else {
        /* Avoid the fabs() call */
        deltahPrime = hPrime2 - hPrime1;
        if (deltahPrime < -deg180InRad)
            deltahPrime += deg360InRad;
        else if (deltahPrime > deg180InRad)
            deltahPrime -= deg360InRad;
    }
    /* Equation 11 */
    deltaHPrime = 2.0 * sqrt(CPrimeProduct) * sin(deltahPrime / 2.0);
    
    /*
     * Step 3
     */
    /* Equation 12 */
    barLPrime = (lab1->l + lab2->l) / 2.0;
    /* Equation 13 */
    barCPrime = (CPrime1 + CPrime2) / 2.0;
    /* Equation 14 */
    hPrimeSum = hPrime1 + hPrime2;
    if (CPrime1 * CPrime2 == 0) {
        barhPrime = hPrimeSum;
    } else {
        if (fabs(hPrime1 - hPrime2) <= deg180InRad)
            barhPrime = hPrimeSum / 2.0;
        else {
            if (hPrimeSum < deg360InRad)
                barhPrime = (hPrimeSum + deg360InRad) / 2.0;
            else
                barhPrime = (hPrimeSum - deg360InRad) / 2.0;
        }
    }
    /* Equation 15 */
    T = 1.0 - (0.17 * cos(barhPrime - deg2Rad(30.0))) +
    (0.24 * cos(2.0 * barhPrime)) +
    (0.32 * cos((3.0 * barhPrime) + deg2Rad(6.0))) -
    (0.20 * cos((4.0 * barhPrime) - deg2Rad(63.0)));
    /* Equation 16 */
    deltaTheta = deg2Rad(30.0) *
    exp(-pow((barhPrime - deg2Rad(275.0)) / deg2Rad(25.0), 2.0));
    /* Equation 17 */
    R_C = 2.0 * sqrt(pow(barCPrime, 7.0) /
                     (pow(barCPrime, 7.0) + pow25To7));
    /* Equation 18 */
    S_L = 1 + ((0.015 * pow(barLPrime - 50.0, 2.0)) /
               sqrt(20 + pow(barLPrime - 50.0, 2.0)));
    /* Equation 19 */
    S_C = 1 + (0.045 * barCPrime);
    /* Equation 20 */
    S_H = 1 + (0.015 * barCPrime * T);
    /* Equation 21 */
    R_T = (-sin(2.0 * deltaTheta)) * R_C;
    
    /* Equation 22 */
    deltaE = sqrt(
                  pow(deltaLPrime / (k_L * S_L), 2.0) +
                  pow(deltaCPrime / (k_C * S_C), 2.0) +
                  pow(deltaHPrime / (k_H * S_H), 2.0) +
                  (R_T * (deltaCPrime / (k_C * S_C)) * (deltaHPrime / (k_H * S_H))));
    
    return (deltaE);
}

/* End of external code */
 
/*
 ** My comparison function
 */
double comparison(unsigned char *a, unsigned char *b)
{
    LAB c;
    LAB d;
    
    rgb2lab(a, &c);
    rgb2lab(b, &d);
#if 1   /* The better (yet slow) */
    return CIEDE2000(&c, &d);
#else   /* Not so good */
    return deltaE(&c, &d);
#endif
}

/*
 ** Main program
 */
int main(int argc, char *argv[])
{
    FILE *a;
    int x;
    int y;
    int c;
    int d;
    int e;
    int n;
    unsigned char buffer[54 + 1024];    /* Header and palette */
    unsigned char color_replacement[32];
    int color_replacement_size = 0;
    unsigned char mapping[16];
    int b;
    int g;
    int r;
    int offset;
    int max1;
    int color1;
    int max2;
    int color2;
    int x1;
    int y1;
    int x2;
    int sig_sprite;
    int triple_color;
    int inline_sprites[192];
    
    int bmp_format;
    
    int arg;
    int bad;
    int sprite_mode = 0;
    int flip_x = 0;
    int flip_y = 0;
    int magic_sprites = 0;
    int photo = 0;
    int tiled = 0;
    int start_tile = 0;
    char *output_file = NULL;
    
    time_t actual;
    struct tm *date;
    
    actual = time(0);
    date = localtime(&actual);
    if (argc < 3) {
        fprintf(stderr, "\nConverter from BMP to TMS9928 format\n");
        fprintf(stderr, VERSION "  by Oscar Toledo G. http://nanochess.org\n");
        fprintf(stderr, "\n");
        fprintf(stderr, "Usage:\n\n");
        fprintf(stderr, "    tmscolor [-s] [-e45d2] [-m] image.bmp image.bin\n");
        fprintf(stderr, "        Creates image for use with assembler code\n\n");
        fprintf(stderr, "    -s     Process tiles in chunks of 16 pixels high (sprites).\n");
        fprintf(stderr, "    -t     Generates minimum of tiles required.\n");
        fprintf(stderr, "    -t01   Same but starting at tile $01 ($00-$ff).\n");
        fprintf(stderr, "    -e45d2 Replaces color 4 with 5 and d with 2 before processing.\n");
        fprintf(stderr, "    -fx    Flip image along the X-coordinate (mirror)\n");
        fprintf(stderr, "    -fy    Flip image along the Y-coordinate\n");
        fprintf(stderr, "    -m     Generates magic sprites for areas with more than 2 colors\n");
        fprintf(stderr, "    -c0    Default souped-up palette\n");
        fprintf(stderr, "    -c1    Uses NTSC palette for colors (from CoolCV)\n");
        fprintf(stderr, "    -c2    Uses PAL palette for colors (from CoolCV)\n");
        fprintf(stderr, "    -p1    Searchs best color combination for photo (slow)\n");
        fprintf(stderr, "    -p2    Searchs best color combination for photo (2x2 dither) (slow)\n");
        fprintf(stderr, "    -o result.bmp\n");
        fprintf(stderr, "           Outputs the final image, plus highlight of errors (if any).\n");
        fprintf(stderr, "\n");
        fprintf(stderr, "Tips:\n");
        fprintf(stderr, "    The first half of output file contains bitmap data.\n");
        fprintf(stderr, "    The second half of output file contains color data.\n");
        fprintf(stderr, "    If magic sprites are used this is followed by 2K of sprite data\n");
        fprintf(stderr, "    and 128 bytes of Sprite Attribute Table.\n");
        fprintf(stderr, "\n");
        fprintf(stderr, "    Best photo conversion is generated by this command line.\n");
        fprintf(stderr, "    tmscolor -p2 -c1 photo.bmp photo.bin\n");
        fprintf(stderr, "    Photos will look better if the contrast is good.\n");
        fprintf(stderr, "\n");
        fprintf(stderr, "Thanks to LeandroCorreia for ideas of color conversion.\n");
        fprintf(stderr, "\n");
        return 0;
    }
    arg = 1;
    while (arg < argc && argv[arg][0] == '-') {
        bad = 0;
        c = tolower(argv[arg][1]);
        if (c == 'f') {
            d = tolower(argv[arg][2]);
            if (d == 'x')
                flip_x = 1;
            else if (d == 'y')
                flip_y = 1;
            else
                bad = 1;
        } else if (c == 's') {     /* -s Sprite mode */
            sprite_mode = 1;
        } else if (c == 'e') {  /* -e Color replacement */
            char *ap1 = &argv[arg][2];
            
            while (isxdigit(ap1[0]) && isxdigit(ap1[1])) {
                if (color_replacement_size < 32) {
                    color_replacement[color_replacement_size++] = from_hex(ap1[0]);
                    color_replacement[color_replacement_size++] = from_hex(ap1[1]);
                } else {
                    fprintf(stderr, "Error: too many color replacements in option -e\n");
                }
                ap1 += 2;
            }
        } else if (c == 'm') {  /* -m Magic sprites */
            magic_sprites = 1;
        } else if (c == 'p') {  /* -p Photo */
            d = tolower(argv[arg][2]);
            if (d == '1')
                photo = 1;
            else if (d == '2')
                photo = 2;
            else
                bad = 1;
        } else if (c == 'c') {  /* -c0 Color palette */
            d = tolower(argv[arg][2]);
            if (d == '0')
                ;
            else if (d == '1')
                memcpy(colors, colors_ntsc, sizeof(colors));
            else if (d == '2')
                memcpy(colors, colors_pal, sizeof(colors));
            else
                bad = 1;
        } else if (c == 't') {  /* -t Tiled, -t01 Tiled start at 01 */
            char *ap1 = &argv[arg][2];
            
            if (isxdigit(ap1[0]) && isxdigit(ap1[1]) && ap1[2] == '\0') {
                start_tile = strtol(ap1, NULL, 16);
                tiled = 1;
            } else if (ap1[0] == '\0') {
                tiled = 1;
            } else {
                bad = 1;
            }
        } else if (c == 'o') {  /* -o file.bmp */
            if (arg + 1 >= argc)
                bad = 1;
            else
                output_file = argv[++arg];
        }
        if (bad)
            fprintf(stderr, "Bad option: %s\n", argv[arg]);
        arg++;
    }
    if (arg >= argc) {
        fprintf(stderr, "Missing input file name\n");
        exit(2);
    }
    
    fprintf(stdout, "Processing: %s\n", argv[arg]);
    a = fopen(argv[arg], "rb");
    arg++;
    if (a == NULL) {
        fprintf(stderr, "Missing input file\n");
        exit(2);
    }
    fread(buffer, 1, 54 + 1024, a);
    if (buffer[0] != 'B' || buffer[1] != 'M') {
        fprintf(stderr, "The input file is not in BMP format\n");
        fclose(a);
        exit(3);
    }
    bmp_format = buffer[0x1c];
    if (bmp_format != 8 && bmp_format != 24 && bmp_format != 32) {
        fprintf(stderr, "The input file is in %d bits format (not 8/24/32)\n", bmp_format);
        fclose(a);
        exit(3);
    }
    if (bmp_format == 8) {
        if (buffer[0x2e] != 0 || (buffer[0x2f] != 0 && buffer[0x2f] != 1)) {
            fprintf(stderr, "Unsupported palette for 8 bits format\n");
            fclose(a);
            exit(3);
        }
    }
    if (buffer[0x1e] != 0 || buffer[0x1f] != 0 || buffer[0x20] != 0 || buffer[0x21] != 0) {
        fprintf(stderr, "Cannot handle compressed input files (codec 0x%08x)\n", (buffer[0x21] << 24) | (buffer[0x20] << 16) | (buffer[0x1f] << 8) | (buffer[0x1e]));
        fclose(a);
        exit(3);
    }
    size_x = buffer[0x12] | (buffer[0x13] << 8);
    size_y = buffer[0x16] | (buffer[0x17] << 8);
    if (size_y >= 32768)
        size_y -= 65536;
    if (size_y >= 0) {
        n = 0;
    } else {
        size_y = -size_y;
        n = 1;
    }
    if ((size_x & 7) != 0) {
        fprintf(stderr, "The input file doesn't measure a multiple of 8 in X size (it's %d pixels)\n", size_x);
        fclose(a);
        exit(3);
    }
    if ((size_y & 7) != 0) {
        fprintf(stderr, "The input file doesn't measure a multiple of 8 in Y size (it's %d pixels)\n", size_y);
        fclose(a);
        exit(3);
    }
    if (size_x == 0 || size_y == 0) {
        fprintf(stderr, "There's a weird BMP file in the input. I'm scared...\n");
        fclose(a);
        exit(3);
    }
    bitmap = malloc(size_x * size_y / 8);
    color = malloc(size_x * size_y / 8);
    pattern = malloc(size_x / 8 * size_y / 8);
    source = malloc(size_x * size_y);
    source2 = malloc(size_x * size_y);
    ignore = malloc(size_x * size_y);
    if (bitmap == NULL || color == NULL || pattern == NULL || source == NULL || source2 == NULL || ignore == NULL) {
        fprintf(stderr, "Unable to allocate memory for bitmap\n");
        fclose(a);
        exit(3);
    }
    
    /* Read image and approximate any color to the local palette */
    fseek(a, buffer[10] | (buffer[11] << 8) | (buffer[12] << 16) | (buffer[13] << 24), SEEK_SET);
    for (y = n ? 0 : size_y - 1; n ? y < size_y : y >= 0; n ? y++ : y--) {
        
        /*
         ** If asked for photo quality...
         */
        if (photo) {
            int best_combo;
            double best_combo_difference;
            int best_combo_dither;
            double combo_difference;
            int combo_dither;
            double g;
            double r;
            double b;
            
            for (x = 0; x < size_x; ) {
                if (bmp_format == 8) {            /* 256 color */
                    fread(buffer, 1, 8, a);
                    for (c = 7; c >= 0; c--)
                        memcpy(buffer + c * 4, buffer + 54 + buffer[c] * 4, 4);
                } else if (bmp_format == 24) {    /* 24 bits */
                    for (c = 0; c < 8; c++)
                        fread(buffer + c * 4, 1, 3, a);
                } else {                            /* 32 bits */
                    fread(buffer, 1, 32, a);
                }
                best_combo_difference = 1e38;
                
                /*
                 ** Try all possible combinations of two colors (15 * 15 = 225 possibilities)
                 */
                for (c = 1; c < 16; c++) {
                    for (d = 1; d < 16; d++) {
                        if (d <= c)
                            continue;
                        combo_difference = 0;
                        combo_dither = 0;
                        for (e = 0; e < 32; e += 4) {
                            g = comparison(&buffer[e + 0], &colors[c * 3 + 0]);
                            r = comparison(&buffer[e + 0], &colors[d * 3 + 0]);
                            if (photo == 2) {
                                g = (g < r) ? g : r;
                                r = sqrt(sqr(colors[d * 3 + 2] - colors[c * 3 + 2])
                                + sqr(colors[d * 3 + 1] - colors[d * 3 + 1])
                                         + sqr(colors[d * 3 + 0] - colors[d * 3 + 0]));
                                if (r < 96) {
                                    unsigned char extra[3];
                                    
                                    extra[0] = (colors[d * 3 + 0] + colors[c * 3 + 0]) / 2;
                                    extra[1] = (colors[d * 3 + 1] + colors[c * 3 + 1]) / 2;
                                    extra[2] = (colors[d * 3 + 2] + colors[c * 3 + 2]) / 2;
                                    
                                    r = comparison(&buffer[e + 0], &extra[0]);
                                    g = (g < r) ? g : r;
                                    combo_dither = 1;
                                }
                                combo_difference += g;
                            } else {
                                combo_difference += (g < r) ? g : r;
                            }
                        }
                        if (combo_difference < best_combo_difference) {
                            best_combo = (c << 4) | d;
                            best_combo_difference = combo_difference;
                            best_combo_dither = combo_dither;
                        }
                    }
                }
                for (c = 0; c < color_replacement_size; c += 2) {
                    if ((best_combo >> 4) == color_replacement[c]) {
                        best_combo = (best_combo & 0x0f) | (color_replacement[c + 1] << 4);
                        break;
                    }
                }
                for (c = 0; c < color_replacement_size; c += 2) {
                    if ((best_combo & 0x0f) == color_replacement[c]) {
                        best_combo = (best_combo & 0xf0) | color_replacement[c + 1];
                        break;
                    }
                }
                c = (best_combo >> 4) & 0x0f;
                d = best_combo & 0x0f;
                for (e = 0; e < 32; e += 4) {
                    g = comparison(&buffer[e + 0], &colors[c * 3 + 0]);
                    r = comparison(&buffer[e + 0], &colors[d * 3 + 0]);
                    if (best_combo_dither) {
                        unsigned char extra[3];
                        
                        extra[0] = (colors[d * 3 + 0] + colors[c * 3 + 0]) / 2;
                        extra[1] = (colors[d * 3 + 1] + colors[c * 3 + 1]) / 2;
                        extra[2] = (colors[d * 3 + 2] + colors[c * 3 + 2]) / 2;
                        
                        b = comparison(&buffer[e + 0], &extra[0]);
                        if (b < g && b < r) {
                            source[(flip_y ? size_y - 1 - y : y) * size_x + (flip_x ? size_x - 1 - x : x)] = (y ^ x) & 1 ? c : d;
                        } else {
                            source[(flip_y ? size_y - 1 - y : y) * size_x + (flip_x ? size_x - 1 - x : x)] = (g < r) ? c : d;
                        }
                    } else {
                        source[(flip_y ? size_y - 1 - y : y) * size_x + (flip_x ? size_x - 1 - x : x)] = (g < r) ? c : d;
                    }
                    x++;
                }
            }
        } else {
            
            /*
             ** Normal image
             */
            for (x = 0; x < size_x; x++) {
                int best_color;
                int best_difference;
                
                if (bmp_format == 8) {            /* 256 color */
                    fread(buffer, 1, 1, a);
                    memcpy(buffer, buffer + 54 + buffer[0] * 4, 4);
                } else if (bmp_format == 24) {    /* 24 bits */
                    fread(buffer, 1, 3, a);
                } else {                            /* 32 bits */
                    fread(buffer, 1, 4, a);
                }
                best_color = 0;
                best_difference = 100000;
                for (c = 0; c < 16; c++) {
                    d = (buffer[2] - colors[c * 3 + 2]) * (buffer[2] - colors[c * 3 + 2])
                    + (buffer[1] - colors[c * 3 + 1]) * (buffer[1] - colors[c * 3 + 1])
                    + (buffer[0] - colors[c * 3 + 0]) * (buffer[0] - colors[c * 3 + 0]);
                    if (d < best_difference) {
                        best_difference = d;
                        best_color = c;
                    }
                }
                for (c = 0; c < color_replacement_size; c += 2) {
                    if (best_color == color_replacement[c]) {
                        best_color = color_replacement[c + 1];
                        break;
                    }
                }
                source[(flip_y ? size_y - 1 - y : y) * size_x + (flip_x ? size_x - 1 - x : x)] = best_color;
            }
        }
    }
    fclose(a);
    
    
    /* Open output file and write result */
    if (arg >= argc) {
        fprintf(stderr, "Missing output file name\n");
        free(bitmap);
        free(color);
        exit(2);
    }
    a = fopen(argv[arg], "wb");
    arg++;
    if (a == NULL) {
        fprintf(stderr, "Error while opening output file\n");
        free(bitmap);
        free(color);
        exit(2);
    }
/*    if (arg < argc)
        label = argv[arg];*/
    
    if (size_x == 256 && size_y == 192 && magic_sprites == 1) {
        memset(inline_sprites, 0, sizeof(inline_sprites));
        memset(sprites, 0, sizeof(sprites));
        memset(attr, 0xd1, sizeof(attr));
        sig_sprite = 0;
        
        do {
        hack1:
            triple_color = check_triple_color();
            
            
            if (triple_color == 0)
                break;
            
            //
            // Do passes over image replacing more than 2 colors with
            // 16x16 sprites
            //
            for (c = 0; c < 192; c++) {
                for (d = 0; d < 256; d += 8) {
                    if (ignore[c * size_x + d])
                        continue;
                    //				fprintf(stderr, "Generating sprite at %d,%d (%d,%d,%d)\n", d * 8, c * 8, usage[c][d][0], usage[c][d][1], usage[c][d][2]);
                    
                    b = 0;
                    color2 = 0;
                    max2 = -1;
                    while (1) {
                        g = usage[c / 8][d / 8][b];
                        if (g == 255)
                            break;
                        y1 = c;
                        x1 = d;
                        for (x = 0; x < 16; x++) {
                            for (y = 0; y < 16; y++) {
                                if (x + x1 < 256 && y + y1 < 192 && source[(y + y1) * size_x + x + x1] == g && !ignore[(y + y1) * size_x + x + x1])
                                    break;
                            }
                            if (y < 16) {
                                x1 += x;
                                break;
                            }
                        }
                        x2 = 16;
                        for (x = 15; x >= 0; x--) {
                            for (y = 0; y < 16; y++) {
                                if (x + x1 < 256 && y + y1 < 192 && source[(y + y1) * size_x + x + x1] == g && !ignore[(y + y1) * size_x + x + x1])
                                    break;
                            }
                            if (y < 16) {
                                x2 = x + 1;
                                break;
                            }
                        }
                        for (x = x2 - 16; x < 0; x++) {
                            for (y = 0; y < 16; y++) {
                                if (x + x1 < 256 && y + y1 < 192 && source[(y + y1) * size_x + x + x1] == g && !ignore[(y + y1) * size_x + x + x1])
                                    break;
                            }
                            if (y < 16) {
                                x1 += x;
                                break;
                            }
                        }
                        for (y = 15; y >= 0; y--) {
                            for (x = 0; x < 16; x++) {
                                if (x + x1 < 256 && y + y1 < 192 && source[(y + y1) * size_x + x + x1] == g && !ignore[(y + y1) * size_x + x + x1])
                                    break;
                            }
                            if (x < 16) {
                                y1 -= 15 - y;
                                if (y1 < 0)
                                    y1 = 0;
                                break;
                            }
                        }
                        memcpy(source2, source,size_x * size_y);
                        for (y = 0; y < 16; y++) {
                            for (x = 0; x < 16; x++) {
                                if (x == 0 || ((x + x1) & 7) == 0 && x + x1 < 256 && y + y1 < 192) {
                                    color1 = 255;
                                    e = (x1 + x) & 0xf8;
                                    do {
                                        if (source[(y + y1) * size_x + e] != g)
                                            color1 = source[(y + y1) * size_x + e];
                                    } while (++e & 7) ;
                                    if (color1 == 255)
                                        color1 = 1;
                                }
                                if (y + y1 < 192 && x + x1 < 256) {
                                    if (source[(y + y1) * size_x + x + x1] == g && !ignore[(y + y1) * size_x + x + x1]) {
                                        source[(y + y1) * size_x + x + x1] = color1;
                                    }
                                }
                            }
                        }
                        max1 = triple_color - check_triple_color();
                        memcpy(source, source2, size_x * size_y);
                        check_triple_color();
                        if (max1 > max2) {
                            max2 = max1;
                            color2 = g;
                        }
                        b++;
                    }
                    if (sig_sprite >= 32) {
                        fprintf(stderr, "More than 32 sprites\n");
                        goto hack;
                    }
                    y1 = c;
                    x1 = d;
                    for (x = 0; x < 16; x++) {
                        for (y = 0; y < 16; y++) {
                            if (x + x1 < 256 && y + y1 < 192 && source[(y + y1) * size_x + x + x1] == color2 && !ignore[(y + y1) * size_x + x + x1])
                                break;
                        }
                        if (y < 16) {
                            x1 += x;
                            break;
                        }
                    }
                    x2 = 16;
                    for (x = 15; x >= 0; x--) {
                        for (y = 0; y < 16; y++) {
                            if (x + x1 < 256 && y + y1 < 192 && source[(y + y1) * size_x + x + x1] == color2 && !ignore[(y + y1) * size_x + x + x1])
                                break;
                        }
                        if (y < 16) {
                            x2 = x + 1;
                            break;
                        }
                    }
                    for (x = x2 - 16; x < 0; x++) {
                        for (y = 0; y < 16; y++) {
                            if (x + x1 < 256 && y + y1 < 192 && source[(y + y1) * size_x + x + x1] == color2 && !ignore[(y + y1) * size_x + x + x1])
                                break;
                        }
                        if (y < 16) {
                            x1 += x;
                            break;
                        }
                    }
                    for (y = 15; y >= 0; y--) {
                        for (x = 0; x < 16; x++) {
                            if (x + x1 < 256 && y + y1 < 192 && source[(y + y1) * size_x + x + x1] == color2 && !ignore[(y + y1) * size_x + x + x1])
                                break;
                        }
                        if (x < 16) {
                            y1 -= 15 - y;
                            if (y1 < 0)
                                y1 = 0;
                            break;
                        }
                    }
                    g = sig_sprite * 4;
                    attr[g] = y1 - 1;
                    attr[g + 1] = x1;
                    attr[g + 2] = sig_sprite * 4;
                    attr[g + 3] = color2;
                    //				fprintf(stderr, "%02x,%02x,%02x,%02x\n", y1 - 1, x1, sig_sprite * 4, color2);
                    g = sig_sprite * 32;
                    for (y = 0; y < 16; y++) {
                        for (x = 0; x < 16; x++) {
                            if (x == 0 || ((x + x1) & 7) == 0 && x + x1 < 256 && y + y1 < 192) {
                                color1 = 255;
                                e = (x1 + x) & 0xf8;
                                do {
                                    if (source[(y + y1) * size_x + e] != color2)
                                        color1 = source[(y + y1) * size_x + e];
                                } while (++e & 7) ;
                                if (color1 == 255)
                                    color1 = 1;
                            }
                            if (y + y1 < 192 && x + x1 < 256) {
                                if (source[(y + y1) * size_x + x + x1] == color2 && !ignore[(y + y1) * size_x + x + x1]) {
                                    sprites[g + y + (x / 8) * 16] |= 0x80 >> (x & 7);
                                    source[(y + y1) * size_x + x + x1] = color1;
                                }
                            }
                        }
                    }
                    sig_sprite++;
                    goto hack1;
                }
            }
        } while (1) ;
    }
hack:
    //	fprintf(stderr, "Processing image...\n");
    for (c = 0; c < size_y; c++) {
        for (d = 0; d < size_x; d += 8) {
            offset = c / 8 * size_x + (c & 7) + d;
            color1 = -1;
            color2 = -1;
            for (e = 0; e < 8; e++) {
                if (source[c * size_x + d + e] == color1) {
                } else if (source[c * size_x + d + e] == color2) {
                } else if (color1 == -1) {
                    color1 = source[c * size_x + d + e];
                } else if (color2 == -1) {
                    color2 = source[c * size_x + d + e];
                } else {
                    fprintf(stderr, "More than 2 colors in stripe %d,%d (found %d with %d and %d already)\n", d, c, source[c * size_x + d + e], color1, color2);
                    for (e = 0; e < 8; e++)
                        source[c * size_x + d + e] |= 0x10;
                    break;
                }
            }
            if (color1 == -1)
                color1 = 1;
            if (color2 == -1) {
                if (color1 == 1)
                    color2 = 15;
                else
                    color2 = 1;
            }
            if (color1 < color2) {
                e = color1;
                color1 = color2;
                color2 = e;
            }
            for (e = 0; e < 16; e++)
                mapping[e] = 0;
            mapping[color1] = 0x80;
            mapping[color2] = 0;
            color[offset] = color1 << 4 | color2;
            r = 0;
            for (e = 0; e < 8; e++)
                r |= mapping[source[c * size_x + d + e] & 0x0f] >> e;
            bitmap[offset] = r;
            offset += 8;
        }
    }
    /* Generate output file */
    if (output_file != NULL) {
        FILE *a;
        
        a = fopen(output_file, "wb");
        if (a == NULL) {
            fprintf(stderr, "Unable to write output file \"%s\"\n", output_file);
        } else {
            char header[54];
            
            memset(header, 0, sizeof(header));
            header[0x00] = 'B';     /* Header */
            header[0x01] = 'M';
            c = size_x * size_y * 3 + 54;
            header[0x02] = c;       /* Complete size of file */
            header[0x03] = c >> 8;
            header[0x04] = c >> 16;
            header[0x05] = c >> 24;
            c = 54;
            header[0x0a] = c;       /* Size of header plus palette */
            c = 40;
            header[0x0e] = c;       /* Size of header */
            header[0x12] = size_x;
            header[0x13] = size_x >> 8;
            header[0x16] = size_y;
            header[0x17] = size_y >> 8;
            header[0x1a] = 0x01;    /* 1 plane */
            header[0x1c] = 0x18;    /* 24 bits */
            c = size_x * size_y * 3;
            header[0x22] = c;       /* Complete size of file */
            header[0x23] = c >> 8;
            header[0x24] = c >> 16;
            header[0x25] = c >> 24;
            c = 0x0ec4;             /* 96 dpi */
            header[0x26] = c;       /* X */
            header[0x27] = c >> 8;
            header[0x2a] = c;       /* Y */
            header[0x2b] = c >> 8;
            fwrite(header, 1, sizeof(header), a);
            
            for (y = size_y - 1; y >= 0; y--) {
                for (x = 0; x < size_x; x++) {
                    header[0x00] = colors[(source[y * size_x + x] & 0x0f) * 3];
                    header[0x01] = colors[(source[y * size_x + x] & 0x0f) * 3 + 1];
                    header[0x02] = colors[(source[y * size_x + x] & 0x0f) * 3 + 2];
                    c = (header[0x00] * 30 + header[0x01] * 59 + header[0x02] * 11) / 100;
                    if (source[y * size_x + x] & 0x10) {  /* Error */
                        header[0x00] = c / 8 + 0x80;
                        header[0x01] = c / 4 + 0x80;
                        header[0x02] = c / 2 + 0x80;
                    }
                    fwrite(header, 1, 3, a);
                }
            }
            fclose(a);
        }
    }
    if (tiled) {
        static char bit[256 * 8];
        static char col[256 * 8];
        int start = start_tile;
        int current = start;
        
        memset(bit, 0, sizeof(bit));
        memset(col, 0, sizeof(col));
        for (c = 0; c < size_x / 8 * size_y / 8; c++) {
            d = c * 8;
            for (e = start; e < (current > 256 ? 256 : current); e++) {
                if (memcmp(&bit[e * 8], &bitmap[c * 8], 8) == 0
                    && memcmp(&col[e * 8], &color[c * 8], 8) == 0)
                    break;
            }
            if (e == current) {
                if (current == 256) {
                    fprintf(stderr, "Too many tiles at %d,%d\n", c % (size_x / 8), c / (size_x / 8));
                    current++;
                } else if (current > 256) {
                    current++;
                } else {
                    memcpy(&bit[e * 8], &bitmap[c * 8], 8);
                    memcpy(&col[e * 8], &color[c * 8], 8);
                    current++;
                }
            }
            pattern[c] = e;
        }
        fprintf(stderr, "Total used tiles: %d ($%02x-$%02x)\n", current - start, start_tile, current - 1);
        fwrite(bit, 1, 256 * 8, a);
        fwrite(col, 1, 256 * 8, a);
        fwrite(pattern, 1, size_x / 8 * size_y / 8, a);
    } else if (sprite_mode) {
        for (c = 0; c < size_y; c += 16) {
            for (d = 0; d < size_x; d += 8) {
                fwrite(bitmap + c / 8 * size_x + d, 1, 8, a);
                fwrite(bitmap + (c / 8 + 1) * size_x + d, 1, 8, a);
            }
        }
    } else {
        fwrite(bitmap, 1, size_x * size_y / 8, a);
        fwrite(color, 1, size_x * size_y / 8, a);
    }
    if (magic_sprites) {
        fwrite(sprites, 1, sizeof(sprites), a);
        fwrite(attr, 1, sizeof(attr), a);
    }
    fclose(a);
}
