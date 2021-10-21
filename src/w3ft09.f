C> @file
C> @brief Computes 2.5x2.5 n. hemi. grid-vector
C> @author Joe Sela @date 1980-10-21

C> Computes 2.5 x 2.5 n. hemi. grid of 145 x 37 points
C> from spectral coefficients in a rhomboidal 30 resolution
C> representing a vector field.
C>
C> ### Program History Log:
C> Date | Programmer | Comment
C> -----|------------|--------
C> 1980-10-21 | JOE SELA | Initial.
C> 1981-06-15 | Ralph Jones | Add doc block, clean up source.
C> 1989-01-25 | Ralph Jones | Change to microsoft fortran 4.10.
C> 1990-06-12 | Ralph Jones | Change to sun fortran 1.3.
C> 1991-03-30 | Ralph Jones | Convert to silicongraphics fortran.
C> 1993-03-29 | Ralph Jones | Add save statement.
C> 1993-07-22 | Ralph Jones | Change double precision to real for cray.
C>
C> @param[in] VLN 992 complex coeff.
C> @param[in] PLN 992 space for legendre polynomials.
C> @param[in] EPS 992 real space for coeffs. used in computing pln.
C> @param[in] FL 31 complex space for fourier coeff.
C> @param[in] WORK 144 work space for subr. w3ft12
C> @param[in] TRIGS 216 precomputed trig funcs. Used in w3ft12(), computed by w3fa13()
C> @param[in] RCOS 37 reciprocal cosine latitudes of 2.5 x 2.5 grid must be
C> computed before first call to w3ft11() using sr w3fa13.
C> @param[out] GN (145,37) grid values. 5365 point grid is type 29 or 1d o.n. 84
C>
C> @note This subroutine was optimized to run in a small amount of
C> memory, it is not optimized for speed, 70 percent of the time is
C> used by subroutine w3fa12() computing the legendre polynomials. since
C> the legendre polynomials are constant they need to be computed
C> only once in a program. By moving w3fa12() to the main program and
C> computing pln as a (32,31,37) array and changing this subroutine
C> to use pln as a three dimension array you can cut the running time
C> 70 percent.
C>
C> @author Joe Sela @date 1980-10-21
      SUBROUTINE W3FT09(VLN,GN,PLN,EPS,FL,WORK,TRIGS,RCOS)
C
       COMPLEX          FL( 31 )
       COMPLEX          VLN( 32 , 31 )
C
       REAL             COLRA
       REAL             EPS(992)
       REAL             GN(145,37)
       REAL             PLN( 32 , 31 )
       REAL             RCOS(37)
       REAL             TRIGS(216)
       REAL             WORK(144)
C
       SAVE
C
       DATA  PI    /3.14159265/
C
         DRAD = 2.5 * PI / 180.0
C
         DO 400 LAT = 2,37
           LATN  = 38 - LAT
           COLRA = (LAT - 1) * DRAD
           CALL W3FA12(PLN,COLRA, 30 ,EPS)
C
           DO 100 L = 1, 31
             FL(L) = (0.,0.)
 100       CONTINUE
C
             DO 300 L = 1, 31
C
               DO 200 I = 1, 32
                 FL(L) = FL(L) + CMPLX(PLN(I,L) * REAL(VLN(I,L)),
     &           PLN(I,L) * AIMAG(VLN(I,L)) )
 200           CONTINUE
C
             FL(L)=CMPLX(REAL(FL(L))*RCOS(LAT),AIMAG(FL(L))*RCOS(LAT))
 300         CONTINUE
C
         CALL W3FT12(FL,WORK,GN(1,LATN),TRIGS)
C
 400     CONTINUE
C
C***   POLE ROW=CLOSEST LATITUDE ROW
C
         DO 500 I = 1,145
           GN(I,37) = GN(I,36)
 500     CONTINUE
C
         RETURN
       END
