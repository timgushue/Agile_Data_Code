/* Set Home Directory - where we install software */
%default HOME `echo \$HOME/Software/`

/* Load Avro jars and define shortcut */
REGISTER $HOME/pig/build/ivy/lib/Pig/avro-1.5.3.jar
REGISTER $HOME/pig/build/ivy/lib/Pig/json-simple-1.1.jar
REGISTER $HOME/pig/contrib/piggybank/java/piggybank.jar

DEFINE AvroStorage org.apache.pig.piggybank.storage.avro.AvroStorage();

/* MongoDB libraries and configuration */
REGISTER $HOME/mongo-hadoop/mongo-2.10.1.jar                        -- mongodb java driver
REGISTER $HOME/mongo-hadoop/core/target/mongo-hadoop-core-1.1.0.jar -- mongo-hadoop core lib
REGISTER $HOME/mongo-hadoop/pig/target/mongo-hadoop-pig-1.1.0.jar   -- mongo-hadoop pig lib

/* Set speculative execution off so we don't have the chance of duplicate records in Mongo */
SET mapred.map.tasks.speculative.execution false
SET mapred.reduce.tasks.speculative.execution false
DEFINE MongoStorage com.mongodb.hadoop.pig.MongoStorage(); /* Shortcut */

avros = LOAD '/Users/ito/Desktop/tmp/my_inbox_directory/tgushue.avro' USING AvroStorage(); /* For example, 'enron.avro' */
STORE avros INTO 'mongodb://localhost/tgushue.emails' USING MongoStorage(); /* For example, 'mongodb://localhost/enron.emails' */
