# frozen_string_literal: true

class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data = nil)
    @data = data
    @left = nil
    @right = nil
  end

  def <=>(other)
    data.size <=> other.data.size
  end
end

class Tree
  attr_accessor :sorted_array, :root

  def initialize(array)
    @sorted_array = array.sort.uniq
    @root = build_tree(@sorted_array)
  end

  def build_tree(array)
    return nil if array.empty?

    mid = array.length / 2
    root_node = Node.new(array[mid])
    root_node.left = build_tree(array[0...mid])
    root_node.right = build_tree(array[mid + 1..-1])
    root_node
  end

  def pretty_print(node = root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│ ' : ' '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? ' ' : '│ '}", true) if node.left
  end

  def pre_order(node)
    return nil if node.nil?

    print "#{node.data}, "
    pre_order(node.left)
    pre_order(node.right)
  end
end

tree = Tree.new([1, 2, 3, 4, 5, 6, 7])

p tree.pre_order(tree.root)
tree.pretty_print
