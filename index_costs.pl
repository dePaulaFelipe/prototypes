#!/usr/bin/env perl

# This software is for educational purposes only.
# Este software é apenas para fins educacionais.

# Day Trading Tools.
#
# dt_tools/index_costs.pl
# Optimal script to calculate a Day Trade's SL, PRICE & SG.
#
# Liquid_Costs (in BRL): score * (volume_costs * volume) +
# orderCosts * (volume * 2).
#
# SL = Liquid_Costs + taxes(Liquid_Costs).
# PRICE = score_value.
# SG = Liquid_Costs - taxes(Liquid_Costs).
#
# Input: See $usage.
# Output: SL PRICE SG
#
# For Daily SL and SG use Input[2] = 1.
# For Monthly SG use Input[2] = 20.
#
# Use GREP to filter optmals.
#
# LICENSE: GNU GPL V2

use v5.30;
use POSIX;

my $usage = "USAGE: index_costs.pl [int(score > 5), int(volume > 0), int(tax >=1 && <=100), int(OrderCosts > 0), float(volumeCost > 0.1)] where only ARGV[0] is mandatory and ARGV[>1] (ARGV[N]) depends on ARGV[n-1]. See the script for default variables and formulas.";
if ($ARGV[0] == "help") { die "$usage\n"; }

# Default and minimal values.
my %defaults = (
    "score" => 5,
    "volume" => 1,
    "tax" => 1,
    "orderCost" => 1,
    "volumeCost" => 0.2,
);

# User Input.
my $score  = $ARGV[0] || die "$usage\n";
my $volume = $ARGV[1] || $defaults{"volume"};
my $tax    = $ARGV[2] || $defaults{"tax"};
my $oc     = $ARGV[3] || $defaults{"orderCost"};
my $vc     = $ARGV[4] || $defaults{"volumeCost"};

if ($score < $defaults{"score"} || $volume < $defaults{"volume"} || $tax < $defaults{"tax"} || $tax > 100 || $oc < $defaults{"orderCost"} || $vc < $defaults{"volumeCost"}) { die "$usage\n"; }

# Formula and Results.
my $result = $score * ($vc * $volume);
my ($costs, $gain) = ($result, $result);
my $cpt = ($oc * $volume) * 2;
my $puta_que_pariu = $costs + ($costs/100) * $tax + $cpt * 2;
my $negative = $costs + ($puta_que_pariu - $costs);
my $positive = $gain - ($puta_que_pariu - $costs);
my $result_negative = ceil($negative);
my $result_positive = floor($positive);

say "For a $score points trade with $volume Volume (At ${tax}% tax):";
say "SL: $result_negative\nPT: $result\nTP: $result_positive\n";
