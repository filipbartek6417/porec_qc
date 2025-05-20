version 1.0

task minimap2_align {
    input {
        String reference_path
        String reads_path
        String output_prefix
    }

    command <<<
        apt-get update && apt-get install -y curl minimap2
        curl -o hs1.fa.gz ~{reference_path}
        curl -o porec.fa.gz ~{reads_path}
        minimap2 -d hs1.mmi hs1.fa.gz
        minimap2 -t 32 -x map-ont -a hs1.mmi porec.fa.gz > ~{output_prefix}.sam
    >>>

    output {
        File sam = "~{output_prefix}.sam"
    }

    runtime {
        cpu: 32
        memory: "64G"
        disks: "local-disk 500 SSD"
        docker: "ubuntu:latest"
    }
}

workflow porec_qc {
  input {
    String reads_path = "https://s3-us-west-2.amazonaws.com/human-pangenomics/submissions/5b73fa0e-658a-4248-b2b8-cd16155bc157--UCSC_GIAB_R1041_nanopore/HG002_R1041_PoreC/Dorado_v4/HG002_1_Dorado_v4_R1041_PoreC_400bps_sup.fastq.gz"
    String reference_path = "https://hgdownload.soe.ucsc.edu/goldenPath/hs1/bigZips/hs1.fa.gz"
    String output_prefix = "porec"
  }

  call minimap2_align {
    input:
      reads_path = reads_path,
      reference_path = reference_path,
      output_prefix = output_prefix
  }

  output {
    File sam = minimap2_align.sam
  }
}
