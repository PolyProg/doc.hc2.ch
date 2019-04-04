#!/bin/bash -eu
# Imports all doc & generate the index

# Languages mapped to links
# Since bash maps suck, we use '_' in keys for spaces and replace them when presenting
declare -A LANGUAGES


# C/C++
# Link is from https://en.cppreference.com/w/Cppreference:Archives (get the direct link by clicking on the "Html Book" release)
rm -rf c_cpp
wget -O cpp.tar.xz http://upload.cppreference.com/mwiki/images/1/17/html_book_20181028.tar.xz
tar -xvf cpp.tar.xz
rm cpp.tar.xz
rm *.tag.xml # useless files
mv reference c_cpp
LANGUAGES['C/C++']='c_cpp/en/index.html'


# Java
# Google "oracle java documentation" to find the latest
rm -rf java
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" `# accept oracle's license automatically` \
     -O java.zip http://download.oracle.com/otn-pub/java/jdk/11.0.2+9/f51449fcd52f4d52b93a989c5c56ed3c/jdk-11.0.2_doc-all.zip
unzip java.zip
rm java.zip
mv docs java
LANGUAGES['Java']='java/api/index.html'

# Python 2
# From https://docs.python.org/2/download.html
rm -rf python2
wget -O python2.tar.bz2 https://docs.python.org/2/archives/python-2.7.16-docs-html.tar.bz2
tar -xvf python2.tar.bz2
rm python2.tar.bz2
mv python-2* python2
LANGUAGES['Python_2']='python2/index.html'

# Python 3
# From https://docs.python.org/3/download.html
rm -rf python3
wget -O python3.tar.bz2 https://docs.python.org/3/archives/python-3.7.3-docs-html.tar.bz2
tar -xvf python3.tar.bz2
rm python3.tar.bz2
mv python-3* python3
LANGUAGES['Python_3']='python3/index.html'


# HTML file for the index
FILE='index.html'
rm -f "$FILE"
# Basic CSS
echo '<style>body{width:60em; margin:2em auto;} h1,h2,h3,li{font-family: sans-serif;} li{margin:1em;} pre{margin:0; padding:1em; background:#e0e0e0; width:60em;}</style>' >> "$FILE"
# Languages
echo '<h1>Contest Documentation</h1>' >> "$FILE"
echo '<h2>Languages and Standard Libraries</h2>' >> "$FILE"
echo '<ul>' >> "$FILE"
for lang in $(echo ${!LANGUAGES[@]} | tr ' ' '\n' | sort); do
  echo "<li><a href=\"${LANGUAGES[$lang]}\">$(echo $lang | sed 's/_/ /')</a></li>" >> "$FILE"
done
echo '</ul>' >> "$FILE"
# Examples
echo '<h2>Sample Code</h2>' >> "$FILE"
for example in examples/*.html; do
  cat "$example" >> "$FILE"
done

echo 'Done! Make sure you edit history so that there is only one commit that adds the documentation files, otherwise the repo gets way too big.'
