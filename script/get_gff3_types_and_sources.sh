#!/bin/bash

release=$1

if [ $# -ne 1 ] ; then
  echo "Usage: get_gff3_types_and_sources.sh WORMBASEVERSION"
  echo "Example: get_gff3_types_and_sources.sh WS240"
  exit 1
fi

json_decoder=$( cat <<EOS
use JSON;
my \$assemblies = decode_json <>;
foreach my \$species (keys %\$assemblies) {
  foreach my \$assembly_array (\$assemblies->{\$species}->{assemblies}) {
    foreach my \$assembly (@\$assembly_array) {
      my \$bioproject_id = \$assembly->{bioproject};
      print "ftp://ftp.wormbase.org/pub/wormbase/releases/$release/species/\$species/\$bioproject_id/\$species.\$bioproject_id.$release.annotations.gff3.gz\n"
    }
  }
}
EOS
)

for gff3_file in `curl "ftp://ftp.wormbase.org/pub/wormbase/releases/$release/species/ASSEMBLIES.$release.json" | tr -d "\n" | perl -e "$json_decoder"` ; do
  curl $gff3_file | gzip -cd | grep -v -E '^#' | cut -f 2,3 | uniq | sort | uniq > "`basename $gff3_file .gff3.gz`.types_and_sources"
done

