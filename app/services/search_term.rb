class SearchTerm
  attr_accessor :resource, :column, :term, :order_by

  def initialize(resource:, column:, term: nil, order_by: { created_at: :desc })
    @resource = resource
    @column   = column
    @term     = term
    @order_by = order_by
  end

  def call
    return resource.all if term.blank?

    resource
      .where(
        resources
          .lower
          .matches("%#{term.downcase}%"))
          .order(order_by)
  end

  private

  def resources
    resource.arel_table[column]
  end
end
