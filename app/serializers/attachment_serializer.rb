class AttachmentSerializer < ActiveModel::Serializer
  delegate :url_helpers, to: 'Rails.application.routes'

  attributes :id, :filename, :url

  def filename
    object.filename.to_s
  end

  def url
    url_helpers.rails_blob_path(object, only_path: true)
  end
end
