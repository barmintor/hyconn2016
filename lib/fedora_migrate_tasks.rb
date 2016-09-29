module Fedora
  module Migrate
    module Tasks
      def self.pid_to_slug(pid)
        pid.split(':').last
      end
      def self.connection
        ActiveFedora.fedora.connection
      end
      def self.solr_connection
        ActiveFedora::SolrService.instance && ActiveFedora::SolrService.instance.conn
      end
      def self.delete_resource(resource)
        connection.delete(resource)
      rescue Ldp::Gone,Ldp::NotFound
      end
      def self.destroy_resource(resource)
        delete_resource(resource)
        delete_resource("#{resource}/fcr:tombstone")
        solr_connection.delete_by_query("id:\"#{resource}\"", params: { 'softCommit' => true }) unless solr_connection.nil?
      end
      def self.destroy_previously_migrated(pid, container=nil)
        resource = (container.nil?) ? "#{pid_to_slug(pid)}" : "#{pid_to_slug(container)}/#{pid_to_slug(pid)}"
        destroy_resource(resource)
      end
      def self.migrate_common(pid)
        puts "would have migrated #{pid}"
      end
      def self.migrate_administrative_set(pid, reload=false, container=nil)
        destroy_previously_migrated(pid,container) if reload
        # do the migration
        migrate_common(pid)
      end
      def self.migrate_file_set(pid, reload=false, container=nil)
        destroy_previously_migrated(pid,container) if reload
        # do the migration
        migrate_common(pid)
      end
      def self.migrate_work(pid, reload=false, container=nil)
        destroy_previously_migrated(pid,container) if reload
        # do the migration
        migrate_common(pid)
      end
      def self.migrate_collection(pid, reload=false, container=nil)
        destroy_previously_migrated(pid,container) if reload
        # do the migration
        migrate_common(pid)
      end
    end
  end
end
