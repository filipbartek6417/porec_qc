version 1.0

task minimap2_align {
    input {
        File reference_path
        File reads_path
    }

    command <<<
        apt-get update && apt-get install -y minimap2
        minimap2 -d hs1.mmi ~{reference_path}
        minimap2 -t 32 -x map-ont -k13 -Y -a hs1.mmi ~{reads_path} > aligned.sam
    >>>

    output {
        File aligned = "aligned.sam"
    }

    runtime {
        cpu: 32
        memory: "100G"
        disks: "local-disk 2000 SSD"
        docker: "ubuntu:latest"
    }
}

workflow porec_qc {
  input {
    String reads_path = "gs://fc-c3eed389-0be2-4bbc-8c32-1a40b8696969/submissions/bd394ffa-b4db-4031-81d6-8bf319b60390/porec_qc/3aa79ef5-c067-4d32-a29a-32fa5c9c378e/call-minimap2_align/porec.fa.gz"
    String reference_path = "gs://fc-c3eed389-0be2-4bbc-8c32-1a40b8696969/submissions/bd394ffa-b4db-4031-81d6-8bf319b60390/porec_qc/3aa79ef5-c067-4d32-a29a-32fa5c9c378e/call-minimap2_align/hs1.fa.gz"
  }

  call minimap2_align {
    input:
      reads_path = reads_path,
      reference_path = reference_path
  }

  output {
    File aligned = minimap2_align.aligned
  }
}
