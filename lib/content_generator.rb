#
# Copyright 2014, Noah Kantrowitz
# Copyright 2014-2015, Mathieu Sauve-Frankel
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module ContentGenerator
  module ClassMethods
    def attribute(name, options={})
      generator = options.delete(:generator)

      case generator
      when TrueClass
        attr_map = self.content_generators[:default] #~FC001
      when Symbol
        unless self.content_generators.has_key?(generator)
          self.content_generators[generator] = []
        end
        attr_map = self.content_generators[generator]
      else
        raise ArgumentError, "generator must be TrueClass or Symbol"
      end

      attr_map << name

      super
    end

    # thanks noah for helping me figure this out
    def content_generators
      @content_generators ||= if superclass.respond_to?('content_generators')
         superclass.content_generators.dup
      else
        { default: [] }
      end
    end

    def included(klass)
      super
      klass.extend ClassMethods
    end
  end

  extend ClassMethods

  def render(generator: :default)
    buf = String.new
    buf << header if header
    self.class.content_generators[generator].each do |attr|
      line = format_attribute(attr)
      buf << line if line
    end
    buf << footer if footer
    buf
  end

  private

  def header
    nil
  end

  def footer
    nil
  end

  def format_attribute(attr, format="%s = %s\n")
    if self.respond_to?(:"key_formatter_#{attr}")
      key = send(:"key_formatter_#{attr}", attr)
    elsif self.respond_to?(:key_formatter)
      key = send(:key_formatter, attr)
    else
      key = attr
    end

    val = send(attr)
    if val.respond_to?(:empty?) and val.empty?
      nil
    elsif val
      if self.respond_to?(:"value_formatter_#{attr}")
        val = send(:"value_formatter_#{attr}", val)
      elsif self.respond_to?(:value_formatter)
        val = send(:value_formatter, val)
      end
      format % [key, val]
    else
      nil
    end
  end
end
