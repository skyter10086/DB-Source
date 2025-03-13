unit class DB::Source;

use DB::SQLite;
use DB::MySQL;
use DB;
use Grammar::DSN;


has Str $.db-source;

has DB $!data-base;

has Str $.scheme;



submethod BUILD(:$db-source) {
    if Grammar::DSN.parse($db-source).so {
        $!db-source = $db-source;
    }
}


submethod TWEAK() {
    my $dsn = Grammar::DSN.parse($!db-source);
    given $dsn<driver>.Str {
        when /:i sqlite/ { 
            my $host = $dsn<host>.Str;
            $!data-base = DB::SQLite.new: filename => $host ;
            $!scheme = 'sqlite';
        }
        when rx:i/ mysql / { 
            my $user = $dsn<user>.Str;
            my $password = $dsn<password>.Str;
            my $host = $dsn<host>.Str;
            my $port = $dsn<port>.Int;
            my $database = $dsn<database>.Str;
            $!data-base = DB::MySQL.new(
                :host($host)
                :port($port)
                :user($user)
                :password($password)
                :database($database)
            );
            $!scheme = 'mysql';
        }
        when rx:i/ pg | postgres / { ... }
    }
}

method db(--> DB::Connection) {
    return $!data-base.db();
}

=begin pod

=head1 NAME

DB::Source - blah blah blah

=head1 SYNOPSIS

=begin code :lang<raku>

use DB::Source;

=end code

=head1 DESCRIPTION

DB::Source is ...

=head1 AUTHOR

skyter10086 <skyter10086@aliyun.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2025 skyter10086

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
