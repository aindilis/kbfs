(integrate KBFS with magit)

("SHA-1","MD5","CRC32","FileName","FileSize","ProductCode","OpSystemCode","SpecialCode"
"000000206738748EDD92C4E3D2E823896700F849","392126E756571EBF112CB1C1CDEDF926","EBD105A0","I05002T2.PFB",98865,3095,"WIN","")

(add something to prevent it from proceeding if there is an issue
 with extra directories of undefined size, normally there should
 be one for each parent of a dir specified by -d)

./kbfs -n 'sandbox_and_external' -d /media/andrewdo/s3/sandbox /media/andrewdo/s3/external

"./kbfs -n 'sandbox_and_external' -d `chase /var/lib/myfrdcsa/sandbox` `chase /var/lib/myfrdcsa/codebases/external`"

;; (find -not -empty -type f -printf "%s\n" | sort -rn | uniq -d | xargs -I{} -n1 find -type f -size {}c -print0 | xargs -0 md5sum | sort | uniq -w32 --all-repeated=separate)

(KBFS should have a uniform search interface with Sayer, in that
 what you can query about file contents is really similar to what
 you can query about Sayer data)

(KBFS can probably use Sayer.  The idea is, you are simply
 proving things about the contents of the file.  Also need to
 prove things about the relationship between file locations.)

(analyze permissions when building database)

(KBFS can have natural langauge directories i.e.:
 ls "/kbfs/movies containing 'I love you'/"
 ls "/kbfs/texts about artificial intelligence/"
 )

(Part of or a similar project to KBFS should be partially
 concerned with DBMS, but more generally, knowing the storage
 format of databases.  This is related to the overall goal of
 compactly and efficiently storing data.)

(There should be some sort of system, part of KBFS, Pack, and
 FRDCSA-dist, that create FRDCSA recover disks, and that these
 then, testing on what FRDCSA disks are at hand, create plans for
 reconstituting as much of the system as possible.  Also, should
 look at coding theory for ways to disemminate the data into
 secure hands anonymously, for instance, steganographically.
 Perhaps that is why there are so many versions of movies out
 there.)

(Use the 160 GB as a cache when sorting a merging existing files
 in KBFS operations.)

(Review relation between KBFS, Amanda)

(fam in connection with kbfs)

(libsvn-core-perl for KBFS)

(OASIS entity management for KBFS)

(atfs for kbfs)

(add encryption support to KBFS)

(add classification system to KBFS)

(could use KBFS to manage the source directories, etc.  That way,
 it would be much more flexible.)

(the notion of critic applies to clairvoyance and its notion of
 tracking what a user has seen, as well as KBFS, and also relates
 to the general properties of exploration, for instance, in
 searching for documentation about a particular capability.  what
 is the name of the capabilities management system?  cando?)

(the way an auto packager will handle a program tgz is the same
 as the way KBFS and Digest will break it down.)

(KBFS should consider framerd)

(Need to consolidate software that recognizes file types, perhaps
 using MIME, and even learns like my software for files, apply
 this to both files and URL prediction - i.e. learn all
 information from the name and context possible - that\'s a big
 thing, the context.  In fact this is even a bigger problem, but
 can be factored, that deciding how data is to be organized.  We
 have to look into the primary classification rules, for instance,
 that one can classify with a formula, by file type, etc, and come
 up with a scheme for classifying this data.  Ultimately this is
 indeed the KBFS, and so should this predictive capability lie
 within its domain?  Or shouldn\'t it?  These questions are
 interesting, yet my previous background indicates to me they are
 trivial, just not from our vantage.)

(/var/lib/myfrdcsa/kbfs/)

(Interface KBFS with machiavelli to detect sour grapes in public
 domain.)

(Interface spam filtering gnutella client with KBFS and
 [Greenstore])

(recommend items in KBFS to others)

(relfs is to be helped, to be developed into what we are looking
 for.  prepare an email to this person - get him to add security
 classification, as well as other things that come from kbfs.)

(KBFS: Should be a generalized system for looking up directories
 containing stuff and putting these on the command line.)

(Thinking about KBFS pack, it makes at least some sense that,
 with the project still being unclassified, that we implement a
 compressed, cryptographic filesystem on top of a tiny live linux
 disk as the basis of the backup.  An interesting idea is then
 that any machine that has two dvd drives could serve to access
 all the data since we can then have an arbitrary number of
 additional data fses.)

(KBFS should also be concerned with identifing when data is
 missing.)

(By looking at word frequecies, etc, subterm, etc, we can
 practically determine in many cases which documents came from
 which.  This will be useful for KBFS.)

(medusa kbfs)

(Forgot to mention need to work on classification system and KBFS
 using those new perl mods.)

((KBFS -
  http://search.cpan.org/modlist/File_Name_System_Locking))

((KBFS::Pack - Algorithm::Knapsack - brute-force algorithm for
  the knapsack problem))

((KBFS - WebCache::Digest KBFS - WebFS::FileCopy))

((OntoFerret for KBFS::Digest))

(For KBFS?)

(Also, we want to change the library directory of CLEAR to be
 under /var/lib/clear/library or something, or even KBFS)

(Naturally CLEAR should provide the ability to search backwards
 through what has been read, in order to answer questions and so
 forth.  For instance if I read something to the effect that this
 truth is as clear as the sun, searching for this should get me
 the results I want.  This reinforces the notion that clairvoyance
 should keep a central KBFS implementation of voy files, and run
 against that, as these can then easily be equipped for searching
 by a common search interface.)

(could configure CLEAR to use KBFS and then in this way, it would
 be capable of correctly processing documents (as in
					       identification via metadata))

(I bet we could store all personal data on an encrypted loopback
 file system, which would be part of say, KBFS.)

(numerous ideas on the subject: should have classes be a type
 hierarchy.  Maybe build a grpahical tool to interactivcely
 classify these.  Convert these system over to KBFS::Cache,
 keeping a copy of current method.  For each icodebase and
 common (agentified), add a class.  For instance, rather than
 classifying into a vague category, you could classy directly
 to "PSE, goal", etc.)

(Inventory management/KBFS should make use of a common system to
 manage instances of important items/data.)

(Should configure KBFS to start commenting on files.  For
 instance - konik_laird_ilp2004.pdf is related to Corpus.)

(KBFS should track what important project information is where.
 For instance, if we were to move all packages to the projectbox
 server, and delete them to free space, KBFS should know that)

(KBFS should have a classifier that automatically classifies
 items, using the classification system I am to write tonight.)

(KBFS depends on cdcat)

(Duh, KBFS can use KBS)

(Duh KBFS can use KBS)

(KBFS see DircSpan)

(tagfs for kbfs)

(KBFS use SemFS)

(Work on implementing KBFS in OWL)

<REDACTED>

(Should probably make an effort to determine all files that are
 modified by us, and what they are and represent (i.e. kbfs))

(Not only should kbfs know what file a given request matches too,
 but architect (or something) ought to know which functions or
 objects implement the described capabilities.)

(Should break up books into functionality (like CCM) and then
 verify using our kbfs/architect requirements traceability
 mappings.)

(This new system is the basis for critic, kbfs (now we have the
						KB for it), gourmet\'s ontology, etc, etc, etc.)

(We can have kbfs do transparent compression of non-active,
 inefficient files.)

(kbfs should operate like LogicMoo, having a MUD like
 representation of the file system.)

(Develop a self-organizing file system (kbfs).)

(Cleversafe should interface kbfs.)

(kbfs could use dvdisaster)

(I just noticed that with locate, you often get a directory, we
 could design a kbfs version of locate that summarized the
 different chunks.)

(Have a lost and found facility in kbfs, if you have lost any
 files, describe the data, etc.  kbfs may find it for you
 eventually.)

(I think maybe we ought to use kbfs with SourceManager)

(Add to kbfs something that goes around cleaning things up.)

<REDACTED>

(KBFS then ought to have a mode that works like this.  If we have
 file IDs, etc.  We can approximate file derivation from this
 database.  Maybe it should be part of KBFS.)

(Not only should KBFS know what file a given request matches too,
 but architect (or something) ought to know which functions or
 objects implement the described capabilities.)

(Often times, certain files implement certain solutions.  We will
 want to track that information with KBFS.)

(I just noticed that with locate, you often get a directory, we
 could design a KBFS version of locate that summarized the
 different chunks.)

(Should probably make an effort to determine all files that are
 modified by us, and what they are and represent (i.e. KBFS))

(Should break up books into functionality (like CCM) and then
 verify using our KBFS/Architect requirements traceability
 mappings.)
