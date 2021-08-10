#!/usr/bin/perl 


@array=("ls /dev/null","ls -l /dev/null","pwd","ls","id","date","egrep","grep");

while($line = <>){
    
    
    $line =~ s?#!.*?#!/usr/bin/perl -w?;
    $line =~ s?echo '(.*)'?print "$1\\n";?; #From subset 3
    $line =~ s?echo (.*)?print "$1\\n";?;
    $line =~ s?echo "(.*)"?print "$1\\n";?;
    $line =~ s?\b(.*)\b=(.*)?\$$1 = '$2';?;
    $line =~ s?echo (.*) (.*)?print "$1 $2\\n";?;

    
    $line =~ s?cd (.*)?chdir '$1';?;
    $line =~ s?'/tmp '?'/tmp'?;
    $line =~ s/read (.*)/\$$1 = <STDIN>; \n    chomp \$$1;/;
    $line =~ s/\bdo\b/{/;
    $line =~ s/done/} /;


    if($line =~ m/\$\d+/ ) {

        $line =~ s/\\n";//;
        $line =~ m/\$(.*)/;
        $argcount = int($1);
        $argcount--;
        $line =~ s/\$(.*)/\$ARGV[$argcount]\\n";/;

    }
    $line =~ s/\$\@/\@ARGV/;
    $line =~ s/=/eq/ if($line =~ /test/ );
    $line =~ s/le/<=/ if($line =~ /test/ );
    $line =~ s/lt/</ if($line =~ /test/ );
    $line =~ s/gt/>/ if($line =~ /test/ );
    $line =~ s/ge/>=/ if($line =~ /test/ );
    $line =~ s/\btest\b (.*)\b (.*) (.*)\b/("$1" $2 "$3")/ if($line =~ /test/ );



    $line =~ s/\bthen\b/{/;
    $line =~ s/\belse\b/} else {/;
    $line =~ s/\belif\b/} elsif/;
    $line =~ s/\bfi\b/}/;

    if ($line =~ /""/ ){

        $line =~ s/"\b/\\"/;
        $line =~ s/\b"/\\"/;
    }

    if ($line =~ m/expr/ ){

        $line =~ s/`expr (.*)`/$1/;
        $line =~ s/'//;
    }
    

    #For Loops:
if($line =~ m/for .* in .*/){

    $line =~ s/\bfor (.*)/foreach \$$1/;
    $line =~ m/in (.*)/;
    my $arr_values = $1;
    
    @array_values = split(' ',$arr_values) if $arr_values;
    
    foreach $item (@array_values){

        if($item =~ /\*\..*/){
            push(@array_values2,"glob'$item'");
            last;
        }

        
        if($item =~ /[A-Za-z].*/){

                push(@array_values2,"'$item',");

        } else {
        push(@array_values2,"$item ,");
        }

    }

    $line =~ s/in .*/(@array_values2)/;
    

    

}

    # End of For Loops:


    # System Calls:

    foreach $element (@array){

        $trim = $line;
        $trim =~ s/\s+$//;

        if( $trim eq $element ){

            $line =~ s?(.*)?system "$1";?;
        }

    }

    # End of System Calls Loop



    print $line;


    
}


print "\n";
