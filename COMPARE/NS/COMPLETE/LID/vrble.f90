module vrble
use prmtr
implicit none
integer i,j,t
integer con
double precision time
double precision omega,csp
double precision,dimension(1:3,xin  :xMax  ,yin  :yMax  )::Vari
double precision,dimension(0:8,xin-1:xMax+1,yin-1:yMax+1)::Fun,Feq,Ftmp
double precision,dimension(    xin  :xMax  ,yin  :yMax  )::x,r
double precision,dimension(0:8                          )::wght,cx,cy,cs
character tmpstring*20
end module vrble
