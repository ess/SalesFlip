namespace(:sunspot) do
  desc 'Start solr'
  task :start => :environment do
    system "sunspot-solr start -p 8982 -d solr/data/development -s solr --pid-dir=tmp/pids -l FINE --log-file=log/sunspot-solr-development.log"
  end

  desc 'Stop solr'
  task :stop => :environment do
    system "sunspot-solr stop -p 8982 -d solr/data/development -s solr --pid-dir=tmp/pids -l FINE --log-file=log/sunspot-solr-development.log"
  end
end
