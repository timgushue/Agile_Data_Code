/* Set Home Directory - where we install software */
%default HOME `echo \$HOME/Software/`

/* Avro uses json-simple, and is in piggybank until Pig 0.12, where AvroStorage and TrevniStorage are builtins */
REGISTER $HOME/pig/build/ivy/lib/Pig/avro-1.5.3.jar
REGISTER $HOME/pig/build/ivy/lib/Pig/json-simple-1.1.jar
REGISTER $HOME/pig/contrib/piggybank/java/piggybank.jar

DEFINE AvroStorage org.apache.pig.piggybank.storage.avro.AvroStorage();

/* Elasticsearch's own jars */
REGISTER $HOME/elasticsearch/lib/*.jar

/* Register wonderdog - elasticsearch integration */
REGISTER $HOME/wonderdog/target/wonderdog-1.0-SNAPSHOT.jar

/* Remove the old email json */
rmf /Users/ito/Desktop/tmp/inbox_json

/* Nuke the elasticsearch emails index, as we are about to replace it. */
sh curl -XDELETE 'http://localhost:9200/inbox/emails'

/* Load Avros, and store as JSON */
emails = LOAD '/Users/ito/Desktop/tmp/my_inbox_directory/tgushue.avro' USING AvroStorage();
STORE emails INTO '/Users/ito/Desktop/tmp/inbox_json' USING JsonStorage();

/* Now load the JSON as a single chararray field, and index it into ElasticSearch with Wonderdog from InfoChimps */
email_json = LOAD '/Users/ito/Desktop/tmp/inbox_json' AS (email:chararray);
STORE email_json INTO 'es://inbox/emails?json=true&size=1000' USING com.infochimps.elasticsearch.pig.ElasticSearchStorage(
  '$HOME/elasticsearch/config/elasticsearch.yml', 
  '$HOME/elasticsearch/plugins');

/* Search for Hadoop to make sure we get a hit in our email index */
sh curl -XGET 'http://localhost:9200/inbox/emails/_search?q=hadoop&pretty=true&size=1'
