#!/usr/bin/env bash
sudo -S <<< "password" docker volume rm $(sudo -S <<< "password" docker volume ls -qf dangling=true)