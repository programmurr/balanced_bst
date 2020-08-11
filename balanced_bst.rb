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

  def insert(root_node, insert_node)
    return root_node = insert_node if root_node.nil?

    if root_node.data < insert_node.data
      if root_node.right
        insert(root_node.right, insert_node)
      else
        root_node.right = insert_node
      end
    else
      if root_node.left
        insert(root_node.left, insert_node)
      else
        root_node.left = insert_node
      end
    end
  end

  def minimum_value_node(node)
    node = node.left until node.left.nil?
    node
  end

  def delete(node, key)
    return node unless node

    if key < node.data
      node.left = delete(node.left, key)
    elsif key > node.data
      node.right = delete(node.right, key)
    else
      if node.left.nil?
        temp = node.right
        node = nil
        return temp
      elsif node.right.nil?
        temp = node.left
        node = nil
        return temp
      end
      temp = minimum_value_node(node.right)
      node.data = temp.data
      node.right = delete(node.right, temp.data)
    end
    node
  end

  def find(node, key)
    return node if node.nil? || node.data == key

    if node.data < key
      find(node.right, key)
    else
      find(node.left, key)
    end
  end

  def height(node)
    return -1 unless node

    left_height = height(node.left)
    right_height = height(node.right)

    if left_height > right_height
      left_height + 1
    else
      right_height + 1
    end
  end

  def level_order(node)
    return nil unless node

    queue = []
    queue.push(node)
    until queue.empty?
      current_node = queue[0]
      print "#{current_node.data} "
      queue.push(current_node.left) if current_node.left
      queue.push(current_node.right) if current_node.right
      queue.shift
    end
  end

  def pre_order(node)
    return nil unless node

    print "#{node.data} "
    pre_order(node.left)
    pre_order(node.right)
  end

  def in_order(node)
    return nil unless node

    in_order(node.left)
    print "#{node.data} "
    in_order(node.right)
  end

  # TODO: Check if this is working correctly
  def post_order(node)
    return nil unless node

    in_order(node.left)
    in_order(node.right)
    print "#{node.data} "
  end
end

tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
tree.pretty_print
p tree.height(tree.root)
