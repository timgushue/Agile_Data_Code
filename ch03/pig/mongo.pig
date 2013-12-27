/* Set Home Directory - where we install software */
%default HOME `echo \$HOME/Software/`

REGISTER $HOME/mongo-hadoop/mongo-2.10.1.jar                        -- mongodb java driver
REGISTER $HOME/mongo-hadoop/core/target/mongo-hadoop-core-1.1.0.jar -- mongo-hadoop core lib
REGISTER $HOME/mongo-hadoop/pig/target/mongo-hadoop-pig-1.1.0.jar   -- mongo-hadoop pig lib

set mapred.map.tasks.speculative.execution false
set mapred.reduce.tasks.speculative.execution false
define MongoStorage com.mongodb.hadoop.pig.MongoStorage();

sent_counts = LOAD '/Users/ito/Desktop/tmp/sent_counts.txt' AS (from:chararray, to:chararray, total:long);
STORE sent_counts INTO 'mongodb://localhost/tgushue.sent_counts' USING com.mongodb.hadoop.pig.MongoStorage();
