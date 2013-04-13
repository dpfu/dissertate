{
while ( match( $0, /((([']*[[:upper:]]+){2,}[']*[[:space:]]*)|[[:upper:]][[:space:]][[:upper:]][[:space:]]|[[:space:]][[:upper:]][[:space:]][[:upper:]])+/) ) {
        rstart  = RSTART
        rlength = RLENGTH
        if ( match( substr($0,RSTART,RLENGTH), /[[:space:]]+$/) ) {
            rlength = rlength - RLENGTH
        }
        $0 = substr($0,1,rstart-1) \
             "\\textsc{" tolower(substr($0,rstart,rlength)) "}" \
             substr($0,rstart+rlength)
   }
   print
}