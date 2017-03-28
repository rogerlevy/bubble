\ Basic graphics wordset
[bu] idiom [draw2d]
import mo/pen

_private
    : push postpone >r ; immediate
    : pop postpone r> ; immediate
    : 2push  postpone push postpone push ; immediate
    : 2pop  postpone pop postpone pop ; immediate
_public

create fore 4 cells allot
: color   ( r g b a )  2af 2swap 2af fore 2v! fore 2 cells + 2v! ;
: color@af  fore @+ swap @+ swap @+ swap @ ;

( Graphics 1 - Bitmaps / Display )

: onto  pop  al_get_target_bitmap push  swap al_set_target_bitmap  call  pop al_set_target_bitmap ;
: blit  ( src sx sy w h ) write-rgba blend>  at@ 0 al_draw_bitmap ;
: bmp   ( w h -- bmp ) 2i al_create_bitmap ;
: clearbmp  ( r g b a bmp )  onto 4af al_clear_to_color ;
: backbuf  display al_get_backbuffer ;
: destroy  al_destroy_bitmap ;
: loadbmp  zstring al_load_bitmap ;
: savebmp  push zstring pop al_save_bitmap ;
: subbmp   ( bmp w h ) at@ 2i 2swap 2i al_create_sub_bitmap ;

: screen  backbuf onto  color@af al_clear_to_color ;
: dims    640 480 ;

( Graphics 2 - Sprites )
: fsprite  ( bmp flip ) push at@ 2af pop al_draw_bitmap ;
: rfsprite ( bmp cx cy ang flip ) push 3af push at@ 2af pop pop al_draw_rotated_bitmap   ;
: sfsprite  ( bmp dw dh flip )  push 2push 0 0 third bmpwh 2af at@ 2af 2pop 2af pop al_draw_scaled_bitmap ;
: rsfsprite ( bmp cx cy sx sy ang flip ) push push 2push at@ 2af 2push 2af 2pop 2af pop 1af pop al_draw_scaled_rotated_bitmap ;
: usfsprite  ( bmp scale flip )  push push dup bmpwh 0.5 0.5 2* pop dup 0 pop rsfsprite ;
: tfsprite  ( bmp flip ) push color@af at@ 2af pop al_draw_tinted_bitmap ;

: sprite   ( bmp ) 0 fsprite ;
: rsprite  ( bmp cx cy ang )  0 rfsprite ;
: ssprite  ( bmp dw dh )  0 sfsprite ;
: rssprite ( bmp cx cy sx sy ang ) 0 rsfsprite ;
: ussprite  ( bmp scale )  0 usfsprite ;
: tsprite  ( bmp r g b a ) 0 tfsprite ;



( Graphics 3 - Text )
variable fnt
: text  zstring push  color@af fnt @ at@ 2af ALLEGRO_ALIGN_LEFT pop al_draw_text ;
: rtext zstring push  color@af fnt @ at@ 2af ALLEGRO_ALIGN_RIGHT pop al_draw_text ;
: ctext zstring push  color@af fnt @ at@ 2af ALLEGRO_ALIGN_CENTER pop al_draw_text ;

( Graphics 4 - Primitives )
\ -1 = hairline thickness
: line   at@ 2swap 4af color@af -1e 1sf al_draw_line ;
: +line  at@ 2+ line ;
: line+  2dup +line +at ;
: pixel  at@ 2af  color@af  al_draw_pixel ;
: tri  ( x y x y x y ) 2push 4af 2pop 2af color@af -1e 1sf al_draw_triangle ;
: trif  ( x y x y x y ) 2push 4af 2pop 2af color@af al_draw_filled_triangle ;
: rect  ( w h )  at@ 2swap 2over 2+ 4af color@af -1e 1sf al_draw_rectangle ;
: rectf  ( w h )  at@ 2swap 2over 2+ 4af color@af al_draw_filled_rectangle ;
: capsule  ( w h rx ry )  2push at@ 2swap 2over 2+ 4af 2pop 2af color@af -1e 1sf al_draw_rounded_rectangle ;
: capsulef  ( w h rx ry )  2push at@ 2swap 2over 2+ 4af 2pop 2af color@af al_draw_filled_rounded_rectangle ;
: circle  ( r ) at@ rot 3af color@af -1e 1sf al_draw_circle ;
: circlef ( r ) at@ rot 3af color@af al_draw_filled_circle ;
: ellipse  ( rx ry ) at@ 2swap 4af color@af -1e 1sf al_draw_ellipse ;
: ellipsef ( rx ry ) at@ 2swap 4af color@af al_draw_filled_ellipse ;
: arc  ( r a1 a2 )  push at@ 2swap 4af pop 1af color@af -1e 1sf al_draw_arc ;

fixed
( Graphics 5 - Predefined Colors )
: 8>p  s>f 255e f/ f>p ;
: createcolor create 8>p swap 8>p rot 8>p , , , 1 ,  does> 4@ color ;
hex
00 00 00 createcolor black 40 40 40 createcolor dgrey
80 80 80 createcolor grey b0 b0 b0 createcolor lgrey
ff ff ff createcolor white f8 e0 a0 createcolor beige
ff 80 ff createcolor pink ff 00 00 createcolor red
80 00 00 createcolor dkred ff 80 00 createcolor orange
80 40 00 createcolor brown ff ff 00 createcolor yellow
80 80 00 createcolor dyellow 80 ff 00 createcolor neon
00 ff 00 createcolor green 00 80 00 createcolor dgreen
00 ff ff createcolor cyan 00 80 80 createcolor dcyan
00 00 ff createcolor blue 00 00 80 createcolor dblue
80 80 ff createcolor lblue 80 00 ff createcolor violet
40 00 80 createcolor dviolet ff 00 ff createcolor magenta
80 00 80 createcolor dmagenta ff ff 80 createcolor lyellow
e0 e0 80 createcolor khaki decimal
