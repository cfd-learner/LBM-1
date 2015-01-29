subroutine IC !{{{
use prmtr
use vrble
implicit none
double precision tmp(5)
tmp(2)=0d0
do j=yin,yMax
  tmp(1)=0d0
  do i=xin,xMax
    x(i,j) = tmp(1)
    r(i,j) = tmp(2)
    tmp(1)=dx+tmp(1)
  end do 
    tmp(2)=dy+tmp(2)
end do 
open(50,file='grid.d')
do j=yin,yMax
  do i=xin,xMax
    write(50,*) x(i,j),r(i,j)
  end do 
end do 
close(50)

omega = 1d0/(3d0*alpha+5d-1)
wght(0)=4d0/9d0
wght(1)=1d0/9d0
wght(2)=1d0/9d0
wght(3)=1d0/9d0
wght(4)=1d0/9d0
wght(5)=1d0/36d0
wght(6)=1d0/36d0
wght(7)=1d0/36d0
wght(8)=1d0/36d0
  cx(0)= 0d0
  cx(1)= 1d0
  cx(2)= 0d0
  cx(3)=-1d0
  cx(4)= 0d0
  cx(5)= 1d0
  cx(6)=-1d0
  cx(7)=-1d0
  cx(8)= 1d0
  cy(0)= 0d0
  cy(1)= 0d0
  cy(2)= 1d0
  cy(3)= 0d0
  cy(4)=-1d0
  cy(5)= 1d0
  cy(6)= 1d0
  cy(7)=-1d0
  cy(8)=-1d0
  !cs(:)=sqrt(cx(:)**2+cy(:)**2)/sqrt(2d0)
!IC
Vari(1,:,:)=rhoo
Vari(2,:,:)=0d0
Vari(3,:,:)=0d0
Vari(2,:,yMax)=uo

Fun(:, xin-1,:)=Fun(:, xin,:)
Fun(:,xMax+1,:)=Fun(:,xMax,:)
Fun(:,:, yin-1)=Fun(:,:, yin)
Fun(:,:,yMax+1)=Fun(:,:,yMax)
end subroutine IC
!}}}
subroutine BC !{{{
use prmtr
use vrble
implicit none
double precision tmp(5)
do j=yin,yMax
  !BounceBack BCWest
  Fun(1, xin,j)=Fun(3, xin,j)
  Fun(5, xin,j)=Fun(7, xin,j)
  Fun(8, xin,j)=Fun(6, xin,j)
end do
do j=yin,yMax
  !BounceBack BCEast
  Fun(3,xMax,j)=Fun(1,xMax,j)
  Fun(7,xMax,j)=Fun(5,xMax,j)
  Fun(6,xMax,j)=Fun(8,xMax,j)
end do
!do i=xin+1,xMax-1
do i=xin,xMax
  !BounceBack BCSouth
  Fun(2,i, yin)=Fun(4,i,yin)
  Fun(5,i, yin)=Fun(7,i,yin)
  Fun(6,i, yin)=Fun(8,i,yin)
end do
do i=xin+1,xMax-1
  !MovingLid BCNorth
  tmp(1)=Fun(0,i,yMax)+Fun(1,i,yMax)+Fun(3,i,yMax)+2d0*(Fun(2,i,yMax)+Fun(6,i,yMax)+Fun(5,i,yMax))
  Fun(4,i,yMax)=Fun(2,i,yMax)
  Fun(8,i,yMax)=Fun(6,i,yMax)+tmp(1)*uo/6d0
  Fun(7,i,yMax)=Fun(5,i,yMax)-tmp(1)*uo/6d0
end do


Fun(:, xin-1,:)=Fun(:, xin,:)
Fun(:,xMax+1,:)=Fun(:,xMax,:)
Fun(:,:, yin-1)=Fun(:,:, yin)
Fun(:,:,yMax+1)=Fun(:,:,yMax)
end subroutine BC
!}}}
subroutine set_vari!{{{
use prmtr
use vrble
implicit none
integer la
double precision tmp(5)
do j=yin,yMax
  do i=xin,xMax
    tmp(1)=0d0
    do la=0,8
      tmp(1)=tmp(1)+Fun(la,i,j)
    end do
    Vari(1,i,j)=tmp(1)
  end do
end do
do i=xin+1,xMax
  Vari(1,i,yMax)=Fun(0,i,yMax)+Fun(1,i,yMax)+Fun(3,i,yMax)+2d0*(Fun(2,i,yMax)+Fun(6,i,yMax)+Fun(5,i,yMax))
end do
do j=yin,yMax
  do i=xin,xMax-1
    tmp(2)=0d0
    tmp(3)=0d0
    do la=0,8
      tmp(2)=tmp(2)+Fun(la,i,j)*cx(la)
      tmp(3)=tmp(3)+Fun(la,i,j)*cy(la)
    end do
    Vari(2,i,j)=tmp(2)/Vari(1,i,j)
    Vari(3,i,j)=tmp(3)/Vari(1,i,j)
  end do
end do

end subroutine set_vari
!}}}
