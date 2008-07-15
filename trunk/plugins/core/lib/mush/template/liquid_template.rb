module Liquid
  ScriptletSignature           = /\(?[\w\-\.\[\]]\)?/
  ScriptletSegment             = /[\w\-]\??/
  ScriptletStart               = /\[\[/
  ScriptletEnd                 = /\]\]/
  ScriptletIncompleteEnd       = /\]\]?/
  ScriptletParser              = /\[[^\]]+\]|#{ScriptletSegment}+/
  TemplateParser              = /(#{TagStart}.*?#{TagEnd}|#{VariableStart}.*?#{VariableIncompleteEnd}|#{ScriptletStart}.*?#{ScriptletIncompleteEnd})/
end

