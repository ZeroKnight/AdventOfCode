/*
 * Advent of Code 2016: Day 1
 * http://adventofcode.com/2016/day/1
 */

#include <iostream>
#include <fstream>
#include <cmath>
#include <unordered_map>
#include <string>

using namespace std;

enum { NORTH, EAST, SOUTH, WEST };

int main(int argc, char *argv[])
{
  // Part 1
  int count, heading = NORTH, x = 0, y = 0;
  char rot;

  // Part 2
  unordered_map<int, unordered_map<int, int>> city = {
    {0, {
      {0, 1}
    }}
  };
  int distanceHQ = 0;
  string hq;

  ifstream input("./input");
  while (input.get(rot))
  {
    if (rot == 'R')
    {
      if (++heading == 4) heading = NORTH;
    }
    else
    {
      if (--heading == -1) heading = WEST;
    }

    input >> count;
    for (int i = 0; i < count; ++i)
    {
      switch (heading)
      {
        case NORTH: ++y; break;
        case EAST:  ++x; break;
        case SOUTH: --y; break;
        case WEST:  --x; break;
      }

      if (!distanceHQ)
      {
        if (++city[x][y] == 2)
        {
          distanceHQ = abs(x + y);
          hq = to_string(x) + ", " + to_string(y);
        }
      }
    }

    input.ignore(2, ' ');
  }

  cout << "Part 1: " << abs(x - y) << endl;
  cout << "Part 2: " << distanceHQ << " (" << hq << ")\n";

  return 0;
}
