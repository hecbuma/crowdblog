# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  # storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "system/redactor_assets/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fit => [118, 100]
  end
  version :size_a do
    process :resize_to_fit => [380, 200]
  end
  version :size_b do
    process :resize_to_fit => [110, 80]
  end
  version :size_especial do
    process :resize_to_fit => [360, 60]
  end
  version :size_especial_b do
    process :resize_to_fit => [80, 50]
  end
  version :size_d do
    process :resize_to_fit => [180, 160]
  end
  version :size_e do
    process :resize_to_fit => [380, 150]
  end
  version :size_f do
    process :resize_to_fit => [180, 90]
  end
  version :size_g do
    process :resize_to_fit => [380, 220]
  end
  version :size_h do
    process :resize_to_fit => [200, 30]
  end
  version :size_i do
    process :resize_to_fit => [180, 90]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
