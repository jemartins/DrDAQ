#!/bin/bash
#
# $Log: filelist.sh,v $
# Revision 1.2  2006/08/05 00:06:03  jemartins
# changes to get previous dir
#
# Revision 1.1  2006/08/04 23:56:26  jemartins
# initial revision
#
#

WORK_DIR=$HOME/tmp/working
VERSION=3.0.3
NAME=simpl
INST_DIR=usr/src/simpl
PREFIX_DIR=src

echo "%{prefix}/$PREFIX_DIR/$NAME/*" > $NAME-Listprefix
echo "" > $NAME-Listinstall
echo "" > $NAME-DocsList

for i in $WORK_DIR/$NAME/*; do
    #echo $i
    if [ -f $i ]; then
        # Getting name of file
        filename=${i#$WORK_DIR/$NAME/}
        echo "install -D -s -m 655 $filename \$RPM_BUILD_ROOT/$INST_DIR/$filename" >> $NAME-Listinstall
        #echo $filename
    fi
done

for i in $WORK_DIR/$NAME/*; do
    
    if [ -d $i ]; then
        # Getting name of dir
        namedirprev=${i#$WORK_DIR/$NAME/}
        namedir=${i#$WORK_DIR/$NAME/}
        #echo "======="
        #cho $namedir
        #echo "======="
        if [ ! $namedir == "docs" ] || [ ! $namedir == "Docs" ]; then
            echo "%{prefix}/$PREFIX_DIR/$NAME/$namedirprev/*" >> $NAME-Listprefix
        fi

        for j in $i/*; do
            if [ -f $j ]; then
                # Getting name of dir
                namedirprev=${i#$WORK_DIR/$NAME/}
                namedir=${i#$WORK_DIR/$NAME/}
                #echo "======="
                #cho $namedir
                #echo "======="
                # Getting name of file
                filename=${j#$i/}
		#echo "==========="
                #echo "$namedir"
		#echo "==========="
                if [ $namedir == "docs" ]; then
                    echo "%doc $namedirprev1/$filename" >> $NAME-DocsList
                else
                    echo "install -D -s -m 655 $namedirprev/$filename \$RPM_BUILD_ROOT/$INST_DIR/$namedirprev/$filename" >> $NAME-Listinstall
                fi
            else
                # Getting name of dir
                namedirprev=${j#$WORK_DIR/$NAME/}		
                namedir=${j#$i/}
                #echo "======="
                #echo $namedirprev
                #echo "======="
                #echo $namedir

                echo "%{prefix}/$PREFIX_DIR/$NAME/$namedirprev/*" >> $NAME-Listprefix
                
                for k in $j/*; do
                    if [ -f $k ]; then
                    # Getting name of dir
                    namedirprev=${j#$WORK_DIR/$NAME/}		
                    namedir=${j#$i/}
                    #echo "======="
                    #echo $namedirprev
                    #echo "======="
                    #echo $namedir
                    # Getting name of file
                        filename=${k#$j/}
                        #echo $filename
                        #echo $namedirprev/$filename
                        if [ $namedir == "bin" ]; then 
                            PERM=755 
                        else 
                            PERM=655 
                        fi
                        if [ $namedir == "docs" ]; then
                            echo "%doc $namedirprev/$filename >> $NAME-DocsList"
                        else
                            echo "install -D -s -m 655 $namedirprev/$filename \$RPM_BUILD_ROOT/$INST_DIR/$namedirprev/$filename" >> $NAME-Listinstall
                        fi
                    else
                        # Getting name of dir
                        namedirprev=${k#$WORK_DIR/$NAME/}		
                        namedir=${k#$j/}
                        #echo "======="
                        #echo $namedirprev/$namedir
                        #echo "======="
                        
                        echo "%{prefix}/$PREFIX_DIR/$NAME/$namedirprev/*" >> $NAME-Listprefix
                        
                        for l in $k/*; do
                            if [ -f $l ]; then
                                # Getting name of dir
                                namedirprev=${k#$WORK_DIR/$NAME/}		
                                namedir=${k#$j/}
                                #echo "======="
                                #echo $namedirprev/$namedir
                                #echo "======="
                                # Getting name of file
                                filename=${l#$k/}
                                #echo $filename
                                #echo $namedirprev/$namedir
                                #echo $filename
                                if [ $namedir == "bin" ]; then 
                                    PERM=755 
                                else 
                                    PERM=655 
                                fi
                                if [ $namedir == "docs" ] || [ $namedir == "Docs" ]; then
                                    echo "%doc $namedirprev/$filename" >> $NAME-DocsList
                                else
                                    echo "install -D -s -m 655 $namedirprev/$filename \$RPM_BUILD_ROOT/$INST_DIR/$namedirprev/$filename" >> $NAME-Listinstall
                                fi
                            else
                                # Getting name of dir
                                namedirprev=${l#$WORK_DIR/$NAME/}		
                                namedir=${l#$k/}
                                #echo "======="
                                #echo $namedirprev/$namedir
                                #echo "======="
                                #echo $namedir
                            fi
                        done # for l
                    fi
                done # for k
            fi
        done # for j
    fi	
done # for i
