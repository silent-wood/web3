import { DeleteOutlined, EditOutlined } from "@ant-design/icons";
import type { TodoType } from "./index";
import { Space, Tooltip } from "antd";
import React from "react";

interface IProps {
  item: TodoType,
  toggleStatus: (val: string) => void;
  deleteTodo: (val: string) => void;
}

const TodoItem = (props: IProps) => {
  const { item, toggleStatus, deleteTodo } = props;
  const { value, completed } = item;
  return (
    <div className="w-2xs h-8 flex items-center bg-indigo-50 mb-2 px-4">
      <span className="flex-1">{ value }</span>
      <Space>
        {
        completed ? null : <Tooltip title="标记为完成">
        <span onClick={() => toggleStatus(value)} className="cursor-pointer">
          <EditOutlined />
        </span>
      </Tooltip>
    }
      <Tooltip title="删除">
        <span onClick={() => deleteTodo(value)} className="cursor-pointer">
          <DeleteOutlined />
        </span>
      </Tooltip>
      </Space>
      
    
    </div>
  )
}

export default React.memo(TodoItem)