program linkedlist
implicit none
type :: link
integer :: i
type (link), pointer :: next
end type link
type (link), pointer :: first, current
integer :: number
nullify (first)
nullify (current)
! read in a number, until 0 is entered
do
read*, number
if (number == 0) then
exit
end if
allocate (current)
current%i = number
current%next => first
first => current
! create new link
! point to previous link
! update head pointer
end do
! print the contents of the list
current => first
! point to beginning of the list
do
if (.not. associated (current)) then
exit
end if
print*, current%i
current => current%next
! end of list reached
! go the next link in the list
end do
end program linkedlist
