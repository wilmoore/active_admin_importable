module ActiveAdminImportable
  module DSL
    def active_admin_importable(&block)
      action_item :only => :index do
        link_to "Import #{active_admin_config.resource_name.to_s.pluralize}", :action => 'upload_csv'
      end

      collection_action :upload_csv do
        render "admin/csv/upload_csv"
      end

      collection_action :import_csv, :method => :post do
        begin
          CsvDb.convert_save(active_admin_config.resource_class, params[:dump][:file], &block)
        rescue => e
          redirect_to({:action => :index}, {:alert => "#{active_admin_config.resource_name.to_s} import failed due to: #{e.message}"})
        else
          redirect_to({:action => :index}, {:notice => "#{active_admin_config.resource_name.to_s} imported successfully!"})
        end
      end
    end
  end
end
