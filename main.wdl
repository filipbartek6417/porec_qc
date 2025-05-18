version 1.0

task minimap2_align {
    input {
        String reference_path
        String reads_path
        String output_prefix
    }

    command <<<
        apt-get update && apt-get install -y wget gzip
        wget -o hs1.fa.gz ~{reference_path}
        wget -o porec.fa.gz ~{reads_path}
        minimap2 -d hs1.mmi hs1.fa
        minimap2 -t ~{threads} -x map-ont -a ~{ref_index} ~{reads_fastq} > ~{output_prefix}.sam
    >>>

    output {
        File sam = "~{output_prefix}.sam"
    }

    runtime {
        cpu: 32
        memory: "64G"
        disks: "local-disk 300 SSD"
        docker: "quay.io/biocontainers/minimap2:2.24--h5bf99c6_0"
    }
}
