ARG ROS_DISTRO="jazzy"
FROM ros:${ROS_DISTRO}

WORKDIR /agimus-franka-ws

ADD agimus-franka-ws.repos .

RUN vcs import --input agimus-franka-ws.repos

# TODO: if ROS_DISTRO == humble, sed s/rolling/humble agimus-franka-ws.repos

# TODO
RUN sed -i "s/example_robot_data/example_robot_descriptions/" src/mim_solvers/package.xml src/agimus-controller/agimus_controller/package.xml

RUN --mount=type=cache,sharing=locked,target=/var/cache/apt \
    --mount=type=cache,sharing=locked,target=/var/lib/apt \
    apt update \
 && rosdep update \
 && rosdep install --from-paths src --ignore-src -y \
      --skip-keys agimus_demo_04_dual_arm_tiago_pro \
      --skip-keys agimus_demo_07_deburring \
      --skip-keys agimus_demo_09_glue_spreading \
      --skip-keys agimus_pytroller

RUN . /opt/ros/${ROS_DISTRO}/setup.sh \
 && colcon build \
      --packages-skip agimus_demo_07_deburring agimus_demo_04_dual_arm_tiago_pro

ENV LIBGL_ALWAYS_SOFTWARE=1

ENTRYPOINT ["/bin/bash", "-c", "source ./install/setup.bash && exec \"$@\"", "--"]
CMD ["bash"]
