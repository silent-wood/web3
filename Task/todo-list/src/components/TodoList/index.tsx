import { Form, Input, Button, Empty, message, Space } from "antd";
import { useState } from "react";
import TodoItem from "./TodoItem";

export type TodoType = {
  value: string,
  completed: boolean
}

const TodoList = () => {
  const [form] = Form.useForm();

  const [todos, setTodos] = useState<TodoType[]>([]);
  const [inputValue, setInputValue] = useState("");

  const handleChange = (val: string) => {
    form.setFieldValue("name", val)
    setInputValue(val);
  }

  const handleAdd = () => {
    if (!inputValue) return
    if (todos.find(item => item.value === inputValue)) {
      message.warning("重复添加");
      return
    }
    setTodos([...todos, { value: inputValue, completed: false }])
    setInputValue("");
    form.setFieldValue("name", '');
  }

  const toggleStatus = (val: string) => {
    setTodos(prev => {
      const idx = prev.findIndex(item => item.value === val);
      if (idx > -1) {
        prev[idx].completed = true
      }
      return [...prev]
    })
  }

  const deleteTodo = (val: string) => {
    const idx = todos.findIndex(item => item.value === val);
    const list = todos.slice();
    list.splice(idx, 1)
    setTodos(list)
  }

  return (
    <div className="flex flex-col justify-items-center">
      <h2>待办事项</h2>
      <Form form={form}
        layout="inline"
        style={{ margin: "10px 0"}}>
        <Form.Item name="name">
          <Input allowClear onChange={(e) => handleChange(e.target.value)} />
        </Form.Item>
        <Form.Item>
          <Space>
            <Button type="primary" onClick={handleAdd}>新增</Button>
          <Button onClick={() => setTodos([])}>清空</Button>
          </Space>
          
        </Form.Item>
      </Form>
      {
        todos.length ?
          todos.map((item: TodoType) =>
            <TodoItem item={item} key={item.value} toggleStatus={toggleStatus} deleteTodo={deleteTodo} />
          ) :
          <Empty description="暂无待办事项" />
      }
    </div>
  )
}

export default TodoList
