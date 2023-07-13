enum ChangeType
  Improvement
  Feature
  Bugfix

  def css_class
    case self
    in Improvement
      Classes::ImprovementChangeType
    in Feature
      Classes::FeatureChangeType
    in Bugfix
      Classes::BugfixChangeType
    end
  end
end
