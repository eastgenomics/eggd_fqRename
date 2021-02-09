#!/bin/bash
# fqRename 1.0.0

set -e -x -o pipefail

main() {

    echo "Value of fastqs: '${fastqs[@]}'"

    # Create output directories
    mkdir -p out/renamed_fastqs
    mkdir input

    dx-download-all-inputs

    #Add all inputs in the same folder to enable indeces to be found.
    find ~/in -type f -name "*" -print0 | xargs -0 -I {} mv {} ~/input

    cd input


    for i in 1 2; 
       do for sample in *"${i}".fq.gz; 
            
            do if test -f "$sample";
                then
                    echo 'File to be renamed ' "${sample}"; 
                    
                    # Using copy instead of mv to rename the file and keep the original
                    cp  "$sample"  "${sample%.${i}.fq.gz}"_S99_L999_R${i}_001.fastq.gz;
                    
                    # Checks that file and renamed file are the same
                    if cmp -s "$sample" "${sample%.${i}.fq.gz}_S99_L999_R${i}_001.fastq.gz";
                        # If successful, it moves into output to be uploaded
                        then mv ${sample%.${i}.fq.gz}_S99_L999_R${i}_001.fastq.gz /home/dnanexus/out/renamed_fastqs;
                        
                        else exit 1;
                    fi;
            
            else echo No R "${i}" files to be renamed ;
            
            fi
        done ;
    done

    
    # Upload output files
    dx-upload-all-outputs

    echo "Upload Complete"
}

