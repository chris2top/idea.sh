#!/bin/bash
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m' # No Color

#if [ "$1" = "del" ] || [ "$1" = "delete" ]
if [ "$1" = "delete" ]
	then
		if [ -n "$2" ]
			then
				cd $2
				rm -r .idea 
			else
				echo -e "${RED}no project path specified"
		fi




elif [ "$1" = "start" ]
	then
		if [ -n "$2" ]
			then
				project=$2
			else
				project=unfaehig
				echo -e "${RED}no project path specified -> using default path ($project)${NC}"
		fi

		if [ -n "$3" ]
			then
				class=$3
			else
				class="Unfaehig"
				echo -e "${RED}no main class name specified -> using default name Unfaehig${NC}"
		fi

		echo -e "${CYAN}creating mercurial repo...${NC}"
		hg init $project
		echo -e "${CYAN}building project structure...${NC}"
		mkdir $project/src
		mkdir $project/build
		
		echo -e "${CYAN}creating CMakeLists.txt...${NC}"	
		printf "cmake_minimum_required(VERSION 3.5)
project($project LANGUAGES Java)	
find_package(Java 1.8 REQUIRED COMPONENTS Development)
include(UseJava)
file(GLOB_RECURSE SOURCES "src/*.java")
add_jar($project \${SOURCES} ENTRY_POINT $class)
set(CMAKE_JAVA_COMPILE_FLAGS -Xlint:unchecked)" >> $project/CMakeLists.txt

		printf "class $class {\n    public static void main(String[] args){\n        System.out.println(\"WOACADEMY\");\n }\n}" >> $project/src/$class.java

		cd $project/build

		echo -e "${CYAN}trying to cmake build...${NC}"
		cmake ..
		make

		echo -e "${CYAN}trying to execute $project.jar...${NC}"
		java -jar $project.jar 

		cd ../

		sleep 2

		echo -e "${CYAN}adding initial hg commit...${NC}"
		hg st
		hg add
		hg ci -m "Initial Commit"
		hg log -G	

		echo -e "${GREEN}project successfully created - IJ opens immediately${NC}"

		idea ../$project
		
		sleep 1
		clear
#elif [ "$1" = "help" ] || [ "$1" = "-h" ] || [ "$1" = "-help"]
else
	echo ""
 echo -e "----------------------------${RED}HELP${NC}----------------------------"
	echo "|                                                          |"
	echo "| idea.sh start [project-path] [main-class]                |"
	echo "|     creates new cmake project adds hg repo opens it in IJ|"
	echo "|                                                          |"
	echo "| idea.sh delete [project-path]                            |"
	echo "|     deletes all IJ and macOS speficic files              |"
	echo "|                                                          |"
	echo "------------------------------------------------------------"
	echo ""
fi