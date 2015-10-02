set -e

output_file_prefix=`cat output_file_prefix`
file_input="smart-heating.log"
file_tidy="$output_file_prefix.tidy.log"
file_parsed="$output_file_prefix.parsed.log"

cp $file_input $file_tidy

# remove multi line log entries (stack traces) not starting with 2015
sed -E -i 's%^[^0-9]{4}.*%%g'  $file_tidy

# remove empty lines
sed -i '/^$/d' $file_tidy


cp $file_tidy $file_parsed


# split time, microtime, severity, name, message AND add special char to import in excel
sed -E -i 's%^(.{19})(,.{3})\s*\[(\S*)\]\s*(\S+):\s*(.*)%\1§\2§\3§\4§\5%g' $file_parsed

# ^(GET|PUT)\s(coap://\[[a-z0-9:]+)(/\S+)
# \1\t§\2\t§\3\t§
sed -E -i 's%§(GET|PUT)\s(coap://\[[a-z0-9:]+\])(/\S+)%§\1§\2§\3§%g' $file_parsed


# ^(Request timed out:) (\S+) (coap://\S+)
# \1\t§\2\t§\3\t§
sed -E -i 's%§(Request timed out:) (\S+) (coap://\S+)\s*%§\1§\2§\3§%g' $file_parsed


# ^(Could not upload: )
# \1\t§
sed -E -i 's%§(Could not upload:)\s*(\S*)%§\1§\2§%g' $file_parsed


sed -E -i 's%§(upload successful:)\s*(\S*)%§\1§\2§%g' $file_parsed


sed -E -i 's%§(poll)\s*%§\1§%g' $file_parsed

sed -E -i 's%§(Retransmission)%§\1§%g' $file_parsed

# sed -E -i 's%find%replace%g' $file_parsed


