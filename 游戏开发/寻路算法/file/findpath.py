from queue import *
from colorama import init, Fore
import random
init(autoreset=True)

map_data = [
    [1,2,3],
    [4,5,6],
    [7,8,9],
]

class Graph_Node:
    def __init__(self, index, enabled = True ,pos = (0,0)):
        self.index = index
        self.enabled = enabled
        self.step = -1
        self.enter_cost = 1
        self.leave_cost = 0
        self.posX = pos[0]
        self.posY = pos[1]

    def set_enabled(self, enabled = True):
        self.enabled = enabled

    def is_enabled(self):
        return self.enabled
    
    def set_step(self,step = -1):
        self.step = step

    def set_from(self,direction = ""):
        self.direction = direction
    
    def get_from_char(self):
        if not hasattr(self, 'direction'):
            return "--"
        elif self.direction == "N":
            return "↑"
        elif self.direction == "S":
            return "↓"
        elif self.direction == "W":
            return "←"
        elif self.direction == "E":
            return "→"
        elif self.direction == "O":
            return "★"        
        else:
            return "--"        
    
    def set_cost(self,enter_cost = 1,leave_cost = 0):
        self.enter_cost = enter_cost
        self.leave_cost = leave_cost

class Graph:
    def __init__(self, row_num = 1,column_num = 1):
        self.row_num = row_num
        self.column_num = column_num
        self.graph_nodes = []
        self.index_2_node = dict()
        self.__build_graph_node__(self.row_num,self.column_num)
    
    def __build_graph_node__(self,row_num,column_num):
        current_index = 1
        for row in range(0,row_num):
            row_data = []
            self.graph_nodes.append(row_data)
            for column in range(0,column_num):
                node = Graph_Node(current_index,True,(row,column))
                row_data.append(node)
                self.index_2_node[current_index] = node
                current_index += 1

    def print_map(self,show_step = True,show_from = True):
        for row_data in self.graph_nodes:
            column_str = ""
            for column in row_data:
                if column.is_enabled():
                    column_str += Fore.LIGHTCYAN_EX
                else:
                    column_str += Fore.LIGHTMAGENTA_EX
                column_str += str(column.index)
                if show_step == True:
                    column_str += "(%s)"%column.step
                if show_from == True:
                    column_str += "(%s)"%column.get_from_char()
                column_str += "\t"
            print(column_str)

    def print_map_and_path(self,path = [],show_step = True,show_from = True,show_cost=False,show_all_cost=False):
        if len(path) <= 0:
            return
        start_index = path[0]
        target_index = path[len(path) - 1]
        for row_data in self.graph_nodes:
            column_str = ""
            for column in row_data:
                if column.index == start_index:
                    column_str += Fore.LIGHTMAGENTA_EX
                elif column.index == target_index:
                    column_str += Fore.LIGHTYELLOW_EX
                elif column.index in path:
                    column_str += Fore.LIGHTBLUE_EX
                elif column.is_enabled():
                    column_str += Fore.LIGHTCYAN_EX
                else:
                    column_str += Fore.LIGHTRED_EX  
                column_str += str(column.index)
                if show_step == True:
                    column_str += "(%s)"%column.step
                if show_all_cost == True: # Dijkstra算法有
                    if column in self.dj_cost_so_far:
                        column_str += "(%s)"%self.dj_cost_so_far[column]
                    else:
                        column_str += "(%s)"%-1
                elif show_cost == True:
                    column_str += "(%s,%s)"%(column.enter_cost,column.leave_cost)
                if show_from == True:
                    column_str += "(%s)"%column.get_from_char()
                    
                column_str += "\t"
            print(column_str)
    
    def print_step_map(self):
        for row_data in self.graph_nodes:
            column_str = ""
            for column in row_data:
                if column.is_enabled() and column.step != -1:
                    column_str += Fore.LIGHTCYAN_EX + str(column.step)+"\t"
                else:
                    column_str += Fore.LIGHTMAGENTA_EX + str(column.step)+"\t"
            print(column_str)

    def print_from_map(self):
        for row_data in self.graph_nodes:
            column_str = ""
            for column in row_data:
                if column.is_enabled() and hasattr(column,"direction"):
                    column_str += Fore.LIGHTCYAN_EX + column.get_from_char() +"\t"
                else:
                    column_str += Fore.LIGHTMAGENTA_EX + column.get_from_char()+"\t"
            print(column_str)

    def set_enable_node(self,index_list = [],enable = True):
        for index in index_list:
            self.get_node(index).set_enabled(enable)

    def set_random_cost(self):
        for row_data in self.graph_nodes:
            for column in row_data:
                column.set_cost(random.randint(1,10),0)

    def get_node(self,index = 1):
        return self.index_2_node[index]

    def get_neighbors(self,node,use_ugly = True):
        neighbors = []
        column_num = self.column_num
        max_index = self.column_num * self.row_num
        index = node.index
        check_list = []
        # 不同的邻居加入顺序会改变搜索结点的队列顺序，直接影响路径的选择，可搭配print_from_map方法查看不同之处
        # N
        if index - column_num >= 1:
            check_list.append([index - column_num,"S"])
        # S
        if index + column_num <= max_index:
            check_list.append([index + column_num,"N"])
        # E
        if index % column_num != 0:
            check_list.append([index + 1,"W"])
        # W
        if index % column_num != 1:
            check_list.append([index - 1,"E"])

        if use_ugly == True and index  % 2 != 0:
            check_list.reverse()

        for check_info in check_list:
            check_index = check_info[0]
            if check_index in self.index_2_node and self.index_2_node[check_index].is_enabled():
                neighbors.append([self.index_2_node[check_index],check_info[1]])
        return neighbors

    # ---- 广度优先算法 ----
    def build_breadth_first_data(self,target_index = 1,start_index = None ,isdeduce = False):
        if hasattr(self, 'bf_target_index') and self.bf_target_index == target_index:
            return
        self.bf_target_index = target_index
        self.bf_frontier = Queue()
        self.bf_came_from = dict()
        self.bf_target_node = self.get_node(target_index)
        self.bf_target_node.set_step(0)
        self.bf_target_node.set_from("O")
        self.bf_frontier.put(self.bf_target_node)
        self.bf_came_from[self.bf_target_node] = None
        if isdeduce == True:
            print("0退出推演：")
        while not self.bf_frontier.empty():
            if isdeduce == True:
                user_input = input()
                if user_input == "0":
                    break
            current = self.bf_frontier.get()
            if start_index != None and current.index == start_index:
                # 已经可以输出路径
                break
            for next_info in self.get_neighbors(current,True):
                next = next_info[0]
                if next not in self.bf_came_from:
                    self.bf_frontier.put(next)
                    self.bf_came_from[next] = current 
                    next.set_step(current.step + 1)
                    next.set_from(next_info[1])
            if isdeduce == True:
                # self.print_map()
                # self.print_step_map()
                self.print_from_map()

    def get_breadth_first_path(self,start_index = 1,target_index = 1):
        self.build_breadth_first_data(target_index,start_index)
        current = self.get_node(start_index) 
        path = []
        while current != self.bf_target_node: 
            path.append(current.index)
            current = self.bf_came_from.get(current)
            if current == None:
                return []
        path.append(self.bf_target_node.index)
        return path
    
    def print_breadth_first_path(self,start_index = 1,target_index = 1,show_step = True,show_from = True):
        path = self.get_breadth_first_path(start_index,target_index)
        self.print_map_and_path(path,show_step,show_from)
        print("%s -> %s"%(start_index,self.bf_target_node.index),path)
    # ---- 广度优先算法 ----

    # ---- Dijkstra算法 ----
    def get_dijkstra_move_cost(self,current,next):
        return current.leave_cost + next.enter_cost

    def print_dijkstra_map(self,show_all_cost = True):
        for row_data in self.graph_nodes:
            column_str = ""
            if show_all_cost == True:
                for column in row_data:
                    cost = column in self.dj_cost_so_far and self.dj_cost_so_far[column] or -1
                    if column.is_enabled() and hasattr(column,"direction"):
                        column_str += Fore.LIGHTCYAN_EX +"(%s)"%cost + column.get_from_char() +"\t"
                    else:
                        column_str += Fore.LIGHTMAGENTA_EX + "(%s)"%cost +  column.get_from_char()+"\t"
            else:
                for column in row_data:
                    cost = column in self.dj_cost_so_far and "%s,%s"%column.enter_cost,column.leave_cost or -1
                    if column.is_enabled() and hasattr(column,"direction"):
                        column_str += Fore.LIGHTCYAN_EX +"(%s)"%cost + column.get_from_char() +"\t"
                    else:
                        column_str += Fore.LIGHTMAGENTA_EX + "(%s)"%cost +  column.get_from_char()+"\t"
            print(column_str)

    def build_dijkstra_data(self,target_index = 1,start_index = None ,isdeduce = False):
        if hasattr(self, 'dj_target_index') and self.dj_target_index == target_index:
            return
        self.dj_target_index = target_index
        self.dj_frontier = PriorityQueue()
        self.dj_came_from = dict()
        self.dj_cost_so_far = dict()

        self.dj_target_node = self.get_node(target_index)
        self.dj_target_node.set_step(0)
        self.dj_target_node.set_from("O")
        queue_index = 0
        self.dj_frontier.put((0,queue_index,self.dj_target_node))
        self.dj_came_from[self.dj_target_node] = None
        self.dj_cost_so_far[self.dj_target_node] = 0
        if isdeduce == True:
            print("0退出推演：")
        while not self.dj_frontier.empty():
            if isdeduce == True:
                user_input = input()
                if user_input == "0":
                    break
            current_info = self.dj_frontier.get()
            current = current_info[2]
            if start_index != None and current.index == start_index:
                # 已经可以输出路径
                break
            for next_info in self.get_neighbors(current):
                next = next_info[0]
                new_cost = self.dj_cost_so_far[current] + self.get_dijkstra_move_cost(current, next)
                if next not in self.dj_cost_so_far or new_cost < self.dj_cost_so_far[next]:
                    self.dj_cost_so_far[next] = new_cost
                    priority = new_cost
                    queue_index += 1
                    self.dj_frontier.put((priority,queue_index,next))
                    self.dj_came_from[next] = current
                    next.set_step(current.step + 1)
                    next.set_from(next_info[1])
            if isdeduce == True:
                self.print_dijkstra_map()

    def get_dijkstra_path(self,start_index = 1,target_index = 1):
        self.build_dijkstra_data(target_index,start_index)
        current = self.get_node(start_index) 
        path = []
        while current != self.dj_target_node: 
            path.append(current.index)
            current = self.dj_came_from.get(current)
            if current == None:
                return []
        path.append(self.dj_target_node.index)
        return path

    def print_dijkstra_path(self,start_index = 1,target_index = 1,show_step = False,show_from = True,show_cost = True,show_all_cost=False):
        path = self.get_dijkstra_path(start_index,target_index)
        self.print_map_and_path(path,show_step,show_from,show_cost,show_all_cost)
        print("%s -> %s"%(start_index,self.dj_target_node.index),path)
    # ---- Dijkstra算法 ----

    # ---- 贪婪最佳优先算法 ----
    def heuristic(self,node_1, node_2): 
        # 曼哈顿距离
        return abs(node_1.posX - node_2.posX) + abs(node_1.posY - node_2.posY)
    
    def build_greedy_best_first_data(self,target_index = 1,start_index = None ,isdeduce = False):
        if hasattr(self, 'gbf_target_index') and self.gbf_target_index == target_index:
            return
        if start_index == None:
            print('need start_index!')
            return
        self.gbf_target_index = target_index
        self.gbf_frontier = PriorityQueue()
        self.gbf_came_from = dict()

        self.gbf_target_node = self.get_node(target_index)
        self.gbf_start_node = self.get_node(start_index)
        self.gbf_target_node.set_step(0)
        self.gbf_target_node.set_from("O")
        queue_index = 0
        self.gbf_frontier.put((0,queue_index,self.gbf_target_node))
        self.gbf_came_from[self.gbf_target_node] = None
        if isdeduce == True:
            print("0退出推演：")
        while not self.gbf_frontier.empty():
            if isdeduce == True:
                user_input = input()
                if user_input == "0":
                    break
            current_info = self.gbf_frontier.get()
            current = current_info[2]
            if start_index != None and current.index == start_index:
                # 已经可以输出路径
                break
            for next_info in self.get_neighbors(current):
                next = next_info[0]
                if next not in self.gbf_came_from:
                    priority = self.heuristic(self.gbf_start_node,next)
                    queue_index += 1
                    self.gbf_frontier.put((priority,queue_index,next))
                    self.gbf_came_from[next] = current
                    next.set_step(current.step + 1)
                    next.set_from(next_info[1])
            if isdeduce == True:
                self.print_from_map()

    def get_greedy_best_first_path(self,start_index = 1,target_index = 1):
        self.build_greedy_best_first_data(target_index,start_index)
        current = self.get_node(start_index) 
        path = []
        while current != self.gbf_target_node: 
            path.append(current.index)
            current = self.gbf_came_from.get(current)
            if current == None:
                return []
        path.append(self.gbf_target_node.index)
        return path
    
    def print_greedy_best_first_path(self,start_index = 1,target_index = 1,show_step = True,show_from = True):
        path = self.get_greedy_best_first_path(start_index,target_index)
        self.print_map_and_path(path,show_step,show_from)
        print("%s -> %s"%(start_index,self.gbf_target_node.index),path)
    # ---- 贪婪最佳优先算法 ----

    # ---- A*算法 ----
    def print_a_star_map(self,show_all_cost = True):
        for row_data in self.graph_nodes:
            column_str = ""
            if show_all_cost == True:
                for column in row_data:
                    cost = column in self.as_cost_so_far and self.as_cost_so_far[column] or -1
                    if column.is_enabled() and hasattr(column,"direction"):
                        column_str += Fore.LIGHTCYAN_EX +"(%s)"%cost + column.get_from_char() +"\t"
                    else:
                        column_str += Fore.LIGHTMAGENTA_EX + "(%s)"%cost +  column.get_from_char()+"\t"
            else:
                for column in row_data:
                    cost = column in self.as_cost_so_far and "%s,%s"%column.enter_cost,column.leave_cost or -1
                    if column.is_enabled() and hasattr(column,"direction"):
                        column_str += Fore.LIGHTCYAN_EX +"(%s)"%cost + column.get_from_char() +"\t"
                    else:
                        column_str += Fore.LIGHTMAGENTA_EX + "(%s)"%cost +  column.get_from_char()+"\t"
            print(column_str)
    
    def build_a_star_data(self,target_index = 1,start_index = None ,isdeduce = False):
        if hasattr(self, 'as_target_index') and self.as_target_index == target_index:
            return
        self.as_target_index = target_index
        self.as_frontier = PriorityQueue()
        self.as_came_from = dict()
        self.as_cost_so_far = dict()

        self.as_target_node = self.get_node(target_index)
        self.as_start_node = self.get_node(start_index)
        self.as_target_node.set_step(0)
        self.as_target_node.set_from("O")
        queue_index = 0
        self.as_frontier.put((0,queue_index,self.as_target_node))
        self.as_came_from[self.as_target_node] = None
        self.as_cost_so_far[self.as_target_node] = 0
        if isdeduce == True:
            print("0退出推演：")
        while not self.as_frontier.empty():
            if isdeduce == True:
                user_input = input()
                if user_input == "0":
                    break
            current_info = self.as_frontier.get()
            current = current_info[2]
            if start_index != None and current.index == start_index:
                # 已经可以输出路径
                break
            for next_info in self.get_neighbors(current):
                next = next_info[0]
                new_cost = self.as_cost_so_far[current] + self.get_dijkstra_move_cost(current, next)
                if next not in self.as_cost_so_far or new_cost < self.as_cost_so_far[next]:
                    self.as_cost_so_far[next] = new_cost + self.heuristic(self.as_start_node,next)
                    priority = new_cost
                    queue_index += 1
                    self.as_frontier.put((priority,queue_index,next))
                    self.as_came_from[next] = current
                    next.set_step(current.step + 1)
                    next.set_from(next_info[1])
            if isdeduce == True:
                self.print_a_star_map()
    
    def get_a_star_path(self,start_index = 1,target_index = 1):
        self.build_a_star_data(target_index,start_index)
        current = self.get_node(start_index) 
        path = []
        while current != self.as_target_node: 
            path.append(current.index)
            current = self.as_came_from.get(current)
            if current == None:
                return []
        path.append(self.as_target_node.index)
        return path

    def print_a_star_path(self,start_index = 1,target_index = 1,show_step = False,show_from = True,show_cost = True,show_all_cost=False):
        path = self.get_a_star_path(start_index,target_index)
        self.print_map_and_path(path,show_step,show_from,show_cost,show_all_cost)
        print("%s -> %s"%(start_index,self.as_target_node.index),path)
    # ---- A*算法 ----


if __name__ == "__main__":
    graph = Graph(11,11)
    # graph.set_enable_node([22,32,42,52,62,72,18,28,38,48,58,68,78,77,76,75,74,73],False)
    # # ----  广度搜索 ------
    graph.build_breadth_first_data(61) #生成广度搜索
    # graph.print_map()   #打印基本图
    # graph.print_step_map() #打印步数图
    graph.print_from_map() #打印路线图
    # graph.print_breadth_first_path(3,45,False,True)  # 打印广度搜索路线
    # graph.build_breadth_first_data(55,70,True) #演示广度搜索
    # # ----  dijkstra搜索 ------
    # graph.set_random_cost() # 设置dijkstra消耗
    # graph.build_dijkstra_data(55,70,True) # 生成dijkstra
    # graph.print_dijkstra_path(3,45,False,True,False,True) # 打印dijkstra路线
    # # ----  贪婪最佳优先搜索 ------
    # graph.build_greedy_best_first_data(55,70,True) # 打印gbf
    # graph.print_greedy_best_first_path(3,45,False,True) # 打印gbf路线
    # # ----  A*搜索 ------
    # graph.build_a_star_data(89,13,True) # 打印a*
    # graph.print_a_star_path(3,45,False,True,False,True) # 打印a*路线
