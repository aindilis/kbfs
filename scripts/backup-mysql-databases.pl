#!/usr/bin/perl -w

# I am guessing now (Mon Nov 28 22:44:08 CST 2011) that P-D means
# public/data, P-N means public/no-data, V-D means private/data, and
# V-N means private/no-data

use PerlLib::MySQL;
use PerlLib::SwissArmyKnife;

use BOSS::Config;

$specification = "
	--sim		Simulate, but don't actually create a backup

	--no-data	Do not include any data

	--public	Only include data for items that should be public, i.e. CSO / Datamart versus UniLang
";

my $config = BOSS::Config->new
  (Spec => $specification,
   ConfFile => "");
my $conf = $config->CLIConfig;

my $mysql = PerlLib::MySQL->new(DBName => "unilang");

my $res = $mysql->Do(Statement => "show databases");

my $backupdir = "/var/lib/myfrdcsa/codebases/data/kbfs/mysql-backups";

my $date = `date '+%G%m%d%H%M%S'`;
chomp $date;
my $dir = "$backupdir/$date";
if (! $conf->{'--sim'}) {
  system "mkdir -p ".shell_quote($dir);
}

my $tableinfo =
  {
   "Com_elle_bLeaf" => {
			"V-D" => 1,
		       },
   "academician" => {
		     "V-D" => 1,
		    },
   "anymeal" => {
		 "P-D" => 1,
		},
   "classify" => {
		  "P-N" => 1,
		  "V-D" => 1,
		 },
   "cso" => {
	     "P-D" => 1,
	     "V-D" => 1,
	    },
   "datamart_dec2008" => {
			  "P-D" => 1,
			 },
   "elog" => {
	      "P-N" => 1,
	      "V-D" => 1,
	     },
   "folksonomy2" => {
		     "P-D" => 1,
		     "V-D" => 1,
		    },
   "freekbs" => {
		 "P-N" => 1,
		 "V-D" => 1,
		},
   "freekbs2" => {
		  "P-N" => 1,
		  "V-D" => 1,
		 },
   "freekbs2-test" => {
		       "P-N" => 1,
		       "V-D" => 1,
		      },
   "fweb" => {
	      "P-N" => 1,
	      "V-D" => 1,
	     },
   "golden_retriever" => {
			  "P-N" => 1,
			 },
   "gourmet" => {
		 "P-N" => 1,
		 "V-D" => 1,
		},
   "griffith" => {
		  "V-D" => 1,
		 },
   "information_schema" => {
			    "V-D" => 1,
			   },
   "joomla_consultancy" => {
			    "V-D" => 1,
			   },
   "js_rapid_response" => {
			   "P-N" => 1,
			   "V-D" => 1,
			  },
   "js_rapid_response__chris_lampkin" => {
					  "P-N" => 1,
					 },
   "kbarcode" => {
		  "V-N" => 1,
		 },
   "kmax" => {
	      "P-N" => 1,
	      "V-D" => 1,
	     },
   "marketing_manager" => {
			   "P-N" => 1,
			   "V-D" => 1,
			  },
   "michalsen_ip_grouper" => {
			      "V-D" => 1,
			     },
   "mysql" => {
	       # "V-D" => 1,
	      },
   "ossmole_merged" => {
			"P-D" => 1,
		       },
   "perllib_collection" => {
			    "P-N" => 1,
			    "V-D" => 1,
			   },
   "rb_workflow" => {
		     "V-N" => 1,
		    },
   "rhymedict" => {
		   "P-D" => 1,
		  },
   "rp_workflow" => {
		     "V-N" => 1,
		    },
   "sayer" => {
	       "P-N" => 1,
	       "V-D" => 1,
	      },
   "sayer_academician" => {
  			   "P-N" => 1,
  			   "V-D" => 1,
  			  },
   "sayer_corpus" => {
  		      "P-N" => 1,
  		      "V-D" => 1,
  		     },
   "sayer_elle_bleaf" => {
  			  "P-D" => 1,
  			  "V-D" => 1,
  			 },
   "sayer_document_similarity" => {
  				   "P-N" => 1,
  				   "V-D" => 1,
  				  },
   "sayer_ems" => {
  		   "P-N" => 1,
  		   "V-D" => 1,
  		  },
   "sayer_formalize2_preprocessing" => {
  					"P-N" => 1,
  					"V-D" => 1,
  				       },
   "sayer_generic" => {
  		       "P-N" => 1,
  		       "V-D" => 1,
  		      },
   "sayer_its" => {
  		   "V-D" => 1,
  		  },
   "sayer_liferea" => {
  		       "P-N" => 1,
  		       "V-D" => 1,
  		      },
   "sayer_lol" => {
  		   "P-N" => 1,
  		   "V-D" => 1,
  		  },
   "sayer_marketing_manager" => {
  				 "P-N" => 1,
  				 "V-D" => 1,
  				},
   "sayer_nl_to_pddl" => {
  			  "P-N" => 1,
  			  "V-D" => 1,
  			 },

   "sayer_nlu" => {
  		   "P-N" => 1,
  		   "V-D" => 1,
  		  },
   "sayer_nlu_textanalysis" => {
  				"P-N" => 1,
  				"V-D" => 1,
  			       },
   "sayer_org_frdcsa_do" => {
  			     "P-N" => 1,
  			     "V-D" => 1,
  			    },
   "sayer_osbs" => {
  		    "P-N" => 1,
  		    "V-D" => 1,
  		   },
   "sayer_paperlessoffice" => {
  			       "P-N" => 1,
  			       "V-D" => 1,
  			      },
   "sayer_paraphraser" => {
			   "P-N" => 1,
			   "V-D" => 1,
			  },
   "sayer_perllib_easysayer" => {
  				 "P-N" => 1,
  				 "V-D" => 1,
  				},
   "sayer_suppose_suppose" => {
  			       "P-N" => 1,
  			       "V-D" => 1,
  			      },
   "sayer_task1" => {
  		     "P-N" => 1,
  		     "V-D" => 1,
  		    },
   "sayer_test" => {
  		    "P-N" => 1,
  		    "V-D" => 1,
  		   },
   "sayer_tfa" => {
  		   "P-N" => 1,
  		   "V-D" => 1,
  		  },
   "sayer_translate" => {
  			 "P-N" => 1,
  			 "V-D" => 1,
  			},
   "sayer_unilang_webservice" => {
  				  "P-N" => 1,
  				  "V-D" => 1,
  				 },
   "score" => {
  		   "P-N" => 1,
  		   "V-D" => 1,
  		  },
   "shal" => {
  	      "V-N" => 1,
  	     },
   "sr22" => {
  	      "P-D" => 1,
  	     },
   "test" => {
  	      # "V-N" => 1,
  	     },
   "townland" => {
  		  "V-N" => 1,
  		 },
   "unilang" => {
  		 "P-N" => 1,
  		 "V-D" => 1,
  		},
   "wf_workflow" => {
  		     "V-N" => 1,
  		    },
   "wiki1" => {
  	       "V-D" => 1,
  	      },
   "wikiformatter" => {
  		       "V-D" => 1,
  		      },
   "zm" => {
  	    "V-D" => 1,
  	   },
  };

my $donotbackup = {
		   "datamart" => 1,
		   "anymeal" => 1,
		   "apt_file_fast" => 1,
		   # "cso" => 1,
		   # "tm" => 1,
		  };
my $includepublicdata = {
			 "datamart_dec2008" => 1,
			 "gourmet" => 1,
			 "folksonomy2" => 1,
			 "cso" => 1,
			 "normalform" => 1,
			 "rhymedict" => 1,
			 # "sayer" => 1,
			 "sr22" => 1,
			};

foreach my $entry (@$res) {
  my $db = $entry->[0];
  if (scalar keys %{$tableinfo->{$db}}) {
    my $c;
    my $password = read_file("/etc/myfrdcsa/config/perllib");
    chomp $password;
    if (exists $conf->{'--public'}) {
      # this is public
      if (exists $conf->{'--no-data'}) {
	# no data
	# find anything that matches "P-D" or "P-N" and just export
	# the table info
	if (exists $tableinfo->{$db}->{"P-D"} or
	    exists $tableinfo->{$db}->{"P-N"}) {
	  $c = "mysqldump -uroot -p'$password' $db --no-data > $dir/$db.sql";
	}
      } else {
	# with data
	# anything that matches P-D is backed-up with data, anything
	# matching P-N is backed-up without data
	if (exists $tableinfo->{$db}->{"P-D"}) {
	  $c = "mysqldump -uroot -p'$password' $db > $dir/$db.sql";
	}
	if (exists $tableinfo->{$db}->{"P-N"}) {
	  $c = "mysqldump -uroot -p'$password' $db --no-data > $dir/$db.sql";
	}

      }
    } else {
      # this is private
      if (exists $conf->{'--no-data'}) {
	# no data
	# find anything that matches "V-D" or "V-N" and just export
	# the table info
	if (exists $tableinfo->{$db}->{"V-D"} or
	    exists $tableinfo->{$db}->{"V-N"}) {
	  $c = "mysqldump -uroot -p'$password' $db --no-data > $dir/$db.sql";
	}
      } else {
	# with data
	# anything that matches V-D is backed-up with data, anything
	# matching V-N is backed-up without data
	if (exists $tableinfo->{$db}->{"V-D"}) {
	  $c = "mysqldump -uroot -p'$password' $db > $dir/$db.sql";
	}
	if (exists $tableinfo->{$db}->{"V-N"}) {
	  $c = "mysqldump -uroot -p'$password' $db --no-data > $dir/$db.sql";
	}
      }
    }

    if ($c) {
      print "$c\n";
      if (! $conf->{'--sim'}) {
	system "$c";
      }
    }
  } else {
    print "Not backing up $db\n";
  }
}

if (! $conf->{'--sim'}) {
  system "/var/lib/myfrdcsa/codebases/internal/kbfs/scripts/delete-old-backups.pl";
}
