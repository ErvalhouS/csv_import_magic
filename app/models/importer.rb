class Importer < ActiveRecord::Base
  include Paperclip::Glue

  STATUS = %w(pending success error).freeze

  serialize :columns, Array

  has_attached_file :attachment
  has_attached_file :attachment_error

  validates_attachment_content_type :attachment, :attachment_error, content_type: ['text/plain', 'text/csv', 'application/vnd.ms-excel']
  validates_inclusion_of :status, in: STATUS
  validates :attachment, attachment_presence: true
  validates :source, presence: true
  validate :has_no_duplicate_columns

  belongs_to :importable, polymorphic: true

  def source_klass
    source.classify.constantize
  end

  def importable_columns
    source_klass.columns_names
  end

  private

  def has_no_duplicate_columns
    return if columns.empty?

    headers = columns.clone
    headers.delete('ignore')
    errors.add(:columns, :uniq) if headers.size != headers.uniq.size
  end
end
