#!/usr/bin/env python3
"""
LQR Balance Controller - BALANCE ONLY VERSION
"""

import rospy
import numpy as np
from scipy import linalg
from sensor_msgs.msg import Imu
from std_msgs.msg import Float64
import tf.transformations as tf_trans


class LQRBalanceController:
    def __init__(self):
        rospy.init_node('lqr_balance_controller')
        
        # ============== ROBOT PARAMETERS ==============
        self.m_body = 0.406
        self.L = 0.097
        self.I_body = 0.00046
        self.g = 9.81
        
        # ============== STATE VARIABLES ==============
        self.theta = 0.0
        self.theta_dot = 0.0
        self.imu_received = False
        
        # ============== LQR TUNING PARAMETERS ==============
        self.Q_theta = 1190.0
        self.Q_theta_dot = 50.0
        self.R_value = 0.1
        self.velocity_scale = 50.0
        self.max_velocity = 45.0
        
        # Compute LQR gain
        self.K = self.compute_lqr_gain()
        rospy.loginfo(f"LQR Gain K: {self.K}")
        
        # ============== ROS INTERFACE ==============
        self.right_wheel_pub = rospy.Publisher('/right_wheel_velocity_controller/command', Float64, queue_size=10)
        self.left_wheel_pub = rospy.Publisher('/left_wheel_velocity_controller/command', Float64, queue_size=10)
        rospy.Subscriber('/imu/data', Imu, self.imu_callback)
        
        self.rate = rospy.Rate(100)
        rospy.loginfo("LQR Balance Controller initialized!")
    
    def compute_lqr_gain(self):
        m, L, I, g = self.m_body, self.L, self.I_body, self.g
        A = np.array([[0, 1], [m * g * L / I, 0]])
        B = np.array([[0], [1.0 / I]])
        Q = np.diag([self.Q_theta, self.Q_theta_dot])
        R = np.array([[self.R_value]])
        
        try:
            P = linalg.solve_continuous_are(A, B, Q, R)
            K = np.linalg.inv(R) @ B.T @ P
            return K.flatten()
        except Exception as e:
            rospy.logerr(f"LQR solve failed: {e}")
            return np.array([100.0, 10.0])
    
    def quaternion_to_euler(self, q):
        return tf_trans.euler_from_quaternion([q.x, q.y, q.z, q.w])
    
    def imu_callback(self, msg):
        euler = self.quaternion_to_euler(msg.orientation)
        self.theta = euler[1]
        self.theta_dot = msg.angular_velocity.y
        self.imu_received = True
    
    def compute_control(self):
        if not self.imu_received:
            return 0.0
        x = np.array([self.theta, self.theta_dot])
        u = -np.dot(self.K, x)
        wheel_vel = -u * self.velocity_scale
        return np.clip(wheel_vel, -self.max_velocity, self.max_velocity)
    
    def run(self):
        rospy.loginfo("Starting LQR balance control...")
        while not rospy.is_shutdown():
            wheel_vel = self.compute_control()
            
            right_cmd = Float64()
            left_cmd = Float64()
            right_cmd.data = wheel_vel
            left_cmd.data = -wheel_vel
            
            self.right_wheel_pub.publish(right_cmd)
            self.left_wheel_pub.publish(left_cmd)
            
            rospy.loginfo_throttle(1.0, 
                f"Q={self.Q_theta} | theta={np.degrees(self.theta):.1f}deg, "
                f"rate={np.degrees(self.theta_dot):.1f}deg/s, "
                f"cmd={wheel_vel:.1f} (max={self.max_velocity})")
            self.rate.sleep()


if __name__ == '__main__':
    try:
        controller = LQRBalanceController()
        controller.run()
    except rospy.ROSInterruptException:
        pass