#!/usr/bin/perl
use strict;

# Requirements
use JSON::DWIW;
use DBIx::Mint;
use Slurp;
use Mojo::DOM;
use Mojo::UserAgent;
use lib './src/';
use DB::Schema;

# Get configuration file
my $config_file = slurp("config.json");

# Extract object from json
my $config = JSON::DWIW->from_json( $config_file );

# Connect to the database
DBIx::Mint->connect( $config->{dsn}, $config->{username}, $config->{password}, { RaiseError => 1 } );

#my $test = DB::Thing->find_or_create({id_thing => 1});

# For each thing on the website
my $id_thing = 0;
while(1){
    # Find the next thing
    $id_thing++;

    # Get the thing page
    my $ua = Mojo::UserAgent->new;
    my $page = $ua->get('http://www.thingiverse.com/thing:' . $id_thing);
    my $dom = Mojo::DOM->new($page->res->body);

    # Return if there is nothing here
    if( $page->res->body =~ m{THERE IS NOTHING AWESOME HERE} ){ next; }

    print "\nId thing: $id_thing\n";

    # Get the object's name
    my $tittle = $dom->at('div.thing-header-data h1')->text;
    print "Tittle: $tittle\n";

    # Get the author's name
    my $author_name = $dom->at('div.thing-header-data h2 a')->text;
    print "Author: $author_name\n";

    # Get the publication time
    my $time = $dom->at('div.thing-header-data h2 time')->attr('datetime');
    print "Time: $time\n";

    # Get the description's HTML
    my $description = $dom->at('#description')->to_string;
    print "Description: " . length($description) . " bytes\n";

    # Get the instruction's HTML
    my $instruction_div = $dom->at('#instructions');
    my $instructions = $instruction_div ? $instruction_div->to_string : '';
    print "Instructions: " . length($instructions) . " bytes\n";

    # Get license
    my $license = $dom->find('div.license-text a')->[2]->text;
    print "License: $license\n";

    # Insert or update into the database
    my $thing = DB::Thing->find_or_create({ native_thing_id => $id_thing, site_id => 1 });

    # Update that thing
    $thing->tittle( $tittle );
    $thing->site_id(1);
    $thing->url('http://www.thingiverse.com/thing:' . $id_thing);
    $thing->author_name($author_name);
    $thing->description($description);
    $thing->instructions($instructions);
    $thing->license($license);
    $thing->published($time);
    $thing->update();




    # Sleep a bit, don't bother the server too much
    sleep(5);

}





