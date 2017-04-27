program test
   use p0_ubaru_ttbar_config, only: ki, logfile, nlo_prefactors
   use p0_ubaru_ttbar_kinematics, only: dotproduct, boost_to_cms
   use p0_ubaru_ttbar_model, only: parse
   use p0_ubaru_ttbar_matrix, only: samplitude, &
     & initgolem, exitgolem, ir_subtraction
   use p0_ubaru_ttbar_color, only: numcs, CA
   use p0_ubaru_ttbar_rambo, only: ramb

   implicit none

   integer :: NEVT = 1

   integer :: ievt, ierr, prec
   real(ki), dimension(4, 4) :: vecs
   real(ki) :: scale2
   real(ki), dimension(0:3) :: amp
   real(ki), dimension(2:3) :: irp
   real(ki) :: t1, t2

   open(unit=logfile,status='unknown',action='write',file='debug.xml')

   open(unit=10,status='old',action='read',file='param.dat',iostat=ierr)
   if(ierr .eq. 0) then
      call parse(10)
      close(unit=10)
   else
      print*, "No file 'param.dat' found. Using defaults"
   end if

   call initgolem()

   call random_seed

   nlo_prefactors=0  ! Do not include any NLO prefactors in order to recognize
                     ! rational numbers for the pole coefficients

   call cpu_time(t1)
   do ievt = 1, NEVT
!      call ramb(5.0E+02_ki**2, vecs)

!      call boost_to_cms(vecs)

!      scale2 = 2.0_ki * dotproduct(vecs(1,:), vecs(2,:))

      scale2 = 172.5**2

      vecs(1,:) = (/ 1218.0942133429219,        0.0000000000000000,        0.0000000000000000,        1218.0942133429219/)
      vecs(2,:) = (/ 1218.0942133429219,        0.0000000000000000,        0.0000000000000000,        -1218.0942133429219/)
      vecs(3,:) = (/ 1218.0942133429221,        227.58323819675988,       -1044.0408369074330,       -584.75474614663517/)
      vecs(4,:) = (/ 1218.0942133429221,        -227.58323819675988,       1044.0408369074330,       584.75474614663517/)

      call print_parameters(scale2)
      call samplitude(vecs, scale2, amp, prec)
      call ir_subtraction(vecs, scale2, irp)
      if(ievt.eq.NEVT) then
         write(*,'(A1,1x,A17,1x,G23.16)') "#", "LO:", amp(0)
         write(*,'(A1,1x,A17,1x,G23.16)') "#", "NLO, finite part:", &
             &    amp(1)/amp(0)
         write(*,'(A1,1x,A17,1x,G23.16)') "#", "NLO, single pole:", &
             &    amp(2)/amp(0)
         write(*,'(A1,1x,A17,1x,G23.16)') "#", "NLO, double pole:", &
             &    amp(3)/amp(0)
      
      
         write(*,'(A1,1x,A17,1x,G23.16)') "#", "IR,  single pole:", &
            & irp(2)/amp(0)
         write(*,'(A1,1x,A17,1x,G23.16)') "#", "IR,  double pole:", &
            & irp(3)/amp(0)
      
      end if
   end do
   call cpu_time(t2)
   write(*,'(A1,1x,A17,1x,F23.3)') "#", "Time/Event [ms]:", &
      & 1.0E+03 * (t2 - t1) / real(NEVT)

   close(logfile)
   call exitgolem()

 contains

subroutine  print_parameters(scale2)
   use p0_ubaru_ttbar_config, only: renormalisation, &
        convert_to_cdr, reduction_interoperation, &
        reduction_interoperation_rescue, PSP_check, PSP_rescue
   use p0_ubaru_ttbar_model
   implicit none
   real(ki) :: scale2


   write(*,'(A1,1x,A26)') "#", "--------- SETUP ---------"
   write(*,'(A1,1x,A18,I2)') "#", "renormalisation = ", renormalisation

   if(convert_to_cdr) then
      write(*,'(A1,1x,A9,A3)') "#", "scheme = ", "CDR"
   else
      write(*,'(A1,1x,A9,A4)') "#", "scheme = ", "DRED"
   end if

   if(reduction_interoperation.eq.0) then
      write(*,'(A1,1x,A15,A7)') "#", "reduction with ", "SAMURAI"
   else if(reduction_interoperation.eq.1) then
      write(*,'(A1,1x,A15,A7)') "#", "reduction with ", "GOLEM95"
   else if(reduction_interoperation.eq.2) then
      write(*,'(A1,1x,A15,A5)') "#", "reduction with ", "NINJA"
   end if

   if (reduction_interoperation_rescue.ne.reduction_interoperation.and.&
    & PSP_check.and.PSP_rescue) then
      if(reduction_interoperation_rescue.eq.0) then
         write(*,'(A1,1x,A12,A7)') "#", "rescue with ", "SAMURAI"
      else if(reduction_interoperation_rescue.eq.1) then
         write(*,'(A1,1x,A12,A7)') "#", "rescue with ", "GOLEM95"
      else if(reduction_interoperation_rescue.eq.2) then
         write(*,'(A1,1x,A12,A5)') "#", "rescue with ", "NINJA"
      end if
   end if

   write(*,'(A1,1x,A25)') "#", "--- PARAMETER VALUES ---"
   write(*,'(A1,1x,A13)') "#", "Boson masses & widths:"
   write(*,'(A1,1x,A5,G23.16)') "#", "mZ = ", mZ
   write(*,'(A1,1x,A5,G23.16)') "#", "mW = ", mW
   write(*,'(A1,1x,A5,G23.16)') "#", "mH = ", mH
   write(*,'(A1,1x,A5,G23.16)') "#", "wZ = ", wZ
   write(*,'(A1,1x,A5,G23.16)') "#", "wW = ", wW
   write(*,'(A1,1x,A5,G23.16)') "#", "wH = ", wH
   write(*,'(A1,1x,A20)') "#", "Active light quarks:"
   write(*,'(A1,1x,A7,G23.16)') "#", "Nf    =", Nf
   write(*,'(A1,1x,A7,G23.16)') "#", "Nfgen =", Nfgen
   write(*,'(A1,1x,A13)') "#", "Fermion masses & width:"
   write(*,'(A1,1x,A7,G23.16)') "#", "mc   = ", mC
   write(*,'(A1,1x,A7,G23.16)') "#", "mb   = ", mB
   write(*,'(A1,1x,A7,G23.16)') "#", "mbMS = ", mBMS
   write(*,'(A1,1x,A7,G23.16)') "#", "wb   = ", wB
   write(*,'(A1,1x,A7,G23.16)') "#", "mt   = ", mT
   write(*,'(A1,1x,A7,G23.16)') "#", "wt   = ", wT
   write(*,'(A1,1x,A7,G23.16)') "#", "mtau = ", mtau
   write(*,'(A1,1x,A7,G23.16)') "#", "wtau = ", wtau
   write(*,'(A1,1x,A25)') "#", "-------------------------"
   write(*,'(A1,1x,A22)') "#", "Renormalisation scale:"
   write(*,'(A1,1x,A5,G23.16)') "#", "mu = ", sqrt(scale2)
   write(*,'(A1,1x,A25)') "#", "-------------------------"



end subroutine print_parameters

end program test
