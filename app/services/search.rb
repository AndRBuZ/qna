class Search
  attr_reader :query, :scope, :page

  def initialize(query, scope, page = 1)
    @query = ThinkingSphinx::Query.escape(query)
    @scope = scope
    @page = page
  end

  def call
    if scope == 'all'
      ThinkingSphinx.search query, classes: [Question, Answer, Comment, User], page: page
    else
      model_klass.search query, page: page
    end
  end

  private

  def model_klass
    scope.classify.constantize
  end
end
