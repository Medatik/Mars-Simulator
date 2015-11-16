# FMKMF_F90 not set: using f90
# FMKMF_SFTAG not set: using f90
# FMKMF_SPATH not set: using . 
# FMKMF_LINKOPTS not set: using no link options 
# Main program is main.f90 
# process_fsource called with arg main.f90 
# main.f90 Uses Module Controlleur
# Full list of modules in main.f90: Controlleur 
# Uses Controlleur which is in ./Controlleur.f90
# process_fsource called with arg ./Controlleur.f90 
# ./Controlleur.f90 Uses Module PertesUV
# ./Controlleur.f90 Uses Module Sources
# ./Controlleur.f90 Uses Module Affichage
# ./Controlleur.f90 Uses Module readFromFile
# Full list of modules in ./Controlleur.f90: PertesUV Sources Affichage readFromFile 
# Uses PertesUV which is in ./Pertes.f90
# process_fsource called with arg ./Pertes.f90 
# Full list of modules in ./Pertes.f90:  
# Uses Sources which is in ./sources.f90
# process_fsource called with arg ./sources.f90 
# Full list of modules in ./sources.f90:  
# Uses Affichage which is in ./affichage.f90
# process_fsource called with arg ./affichage.f90 
# ./affichage.f90 Uses Module gnufor2
# Full list of modules in ./affichage.f90: gnufor2 
# Uses gnufor2 which is in ./mygnu.f90
# process_fsource called with arg ./mygnu.f90 
# Full list of modules in ./mygnu.f90:  
# Uses readFromFile which is in ./readFromFile.f90
# process_fsource called with arg ./readFromFile.f90 
# Full list of modules in ./readFromFile.f90:  

# ------------------Macro-Defs---------------------
F90=f90 

# -------------------End-macro-Defs---------------------------

# Here is the link step 
main:Pertes.o sources.o mygnu.o affichage.o readFromFile.o Controlleur.o main.o 
	 gfortran -o main Pertes.o sources.o mygnu.o affichage.o readFromFile.o Controlleur.o main.o   

# Here are the compile steps
 
Pertes.o: Pertes.f90  
	 gfortran -c Pertes.f90 

sources.o: sources.f90  
	 gfortran -c sources.f90 

mygnu.o: mygnu.f90  
	 gfortran -c mygnu.f90 

affichage.o: affichage.f90 mygnu.o 
	 gfortran -c affichage.f90 

readFromFile.o: readFromFile.f90  
	 gfortran -c readFromFile.f90 

Controlleur.o: Controlleur.f90 Pertes.o sources.o affichage.o readFromFile.o 
	 gfortran -c Controlleur.f90 

main.o:main.f90 Controlleur.o 
	 gfortran -c main.f90 
# This entry allows you to type " make clean " to get rid of
# all object and module files 
clean:
	rm -f -r f_{files,modd}* *.o *.mod *.M *.d V*.inc *.vo \
	V*.f *.dbg album F.err
  
