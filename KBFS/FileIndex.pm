package KBFS::FileIndex;

# This is a system for recording file derivation information

# When files are openned/editted in Emacs, it contacts us with update
# information.  We use that information to model when and where the
# user has seen a particular file, which is useful to determining how
# familiar they are with the contents.  Ultimately, files are tracked
# and the tasks that these files represent implementations to are
# correlated, for the task tracking mechanism.

# Maybe we should operate on the basis of knowledge base.
