/* Load Avro jars and define shortcut */
REGISTER /me/Software/pig/build/ivy/lib/Pig/avro-1.5.3.jar
REGISTER /me/Software/pig/build/ivy/lib/Pig/json-simple-1.1.jar
REGISTER /me/Software/pig/contrib/piggybank/java/piggybank.jar
define AvroStorage org.apache.pig.piggybank.storage.avro.AvroStorage();

/* MongoDB libraries and configuration */
REGISTER /me/Software/mongo-hadoop-test/mongo-2.10.1.jar
REGISTER /me/Software/mongo-hadoop-test/core/target/mongo-hadoop-core-1.1.0-SNAPSHOT.jar
REGISTER /me/Software/mongo-hadoop-test/pig/target/mongo-hadoop-pig-1.1.0-SNAPSHOT.jar

set mapred.map.tasks.speculative.execution false
set mapred.reduce.tasks.speculative.execution false

/* Set speculative execution off so we don't have the chance of duplicate records in Mongo */
set mapred.map.tasks.speculative.execution false
set mapred.reduce.tasks.speculative.execution false
define MongoStorage com.mongodb.hadoop.pig.MongoStorage(); /* Shortcut */

avros = load '$avros' using AvroStorage(); /* For example, 'enron.avro' */
store avros into '$mongourl' using MongoStorage(); /* For example, 'mongodb://localhost/enron.emails' */