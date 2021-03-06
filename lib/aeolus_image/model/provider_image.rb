#   Copyright 2011 Red Hat, Inc.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

module Aeolus
  module Image
    class ProviderImage < WarehouseModel
      @bucket_name = 'provider_images'

      def initialize(attrs)
        attrs.each do |k,v|
          if [:provider, :target_image].include?(k.to_sym)
            sym = :attr_writer
          else
            sym = :attr_accessor
          end
          self.class.send(sym, k.to_sym) unless respond_to?(:"#{k}=")
          send(:"#{k}=", v)
        end
      end

      def target_image
        TargetImage.find(@target_image) if @target_image
      end

      def provider_name
        @provider
      end

      # Deletes this provider image
      def delete!
        ProviderImage.delete(@uuid)
      end
    end
  end
end
