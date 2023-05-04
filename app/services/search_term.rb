class SearchTerm
  attr_accessor :resource, :column, :term

  def initialize(resource:, column:, term: nil)
    @resource = resource
    @column   = column
    @term     = term
  end

  def call
    return resource.all if term.blank?

    resource
      .where(
        resource
          .arel_table[column]
          .lower
          .matches("%#{term.downcase}%")
      )
  end
end
