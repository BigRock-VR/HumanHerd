using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ModularCity_Script : MonoBehaviour
{

    Transform[] _spawnPoints;
    [SerializeField]
    public GameObject[] _spawnerBuildings;
    [SerializeField]
    public GameObject[] _killerBuildings;
    float[] _rotations;
    private int[] _randomizer = new int[32];
    private float _counter;

    // Start is called before the first frame update
    void Awake()
    {
        _spawnPoints = new Transform[32];
        _rotations = new float[4];
        PopulateArray();
        GenerateCity();
    }

    void PopulateArray()
    {
        for (int i = 0; i < _spawnPoints.Length; i++)
        {
            _spawnPoints[i] = gameObject.transform.GetChild(i).transform;
        }

        for (int i = 0; i < _rotations.Length; i++)
        {
            _rotations[i] = i * 90;
        }

    }

    void GenerateCity()
    {
        if(_killerBuildings != null && _spawnerBuildings != null) {
            for (int i = 0; i < _spawnPoints.Length; i++)
            {
                _randomizer[i] = Random.Range(1, 10);
                if (_randomizer[i] % 2 == 0)
                {
                    Instantiate(_spawnerBuildings[Random.Range(0, _spawnerBuildings.Length)], _spawnPoints[i].transform.position, Quaternion.Euler(0f, _rotations[Random.Range(0, _rotations.Length)], 0), _spawnPoints[i]);
                }
                else if (i - 1 >= 0)
                {
                    if (_randomizer[i - 1] % 2 == 0)
                    {
                        Instantiate(_killerBuildings[Random.Range(0, _killerBuildings.Length)], _spawnPoints[i].transform.position, Quaternion.Euler(0f, _rotations[Random.Range(0, _rotations.Length)], 0), _spawnPoints[i]);
                    }
                    else if (_randomizer[i - 1] % 2 != 0)
                    {
                        Instantiate(_spawnerBuildings[Random.Range(0, _spawnerBuildings.Length)], _spawnPoints[i].transform.position, Quaternion.Euler(0f, _rotations[Random.Range(0, _rotations.Length)], 0), _spawnPoints[i]);
                    }
                }
                else if (_randomizer[i] % 2 != 0)
                {
                    Instantiate(_killerBuildings[Random.Range(0, _killerBuildings.Length)], _spawnPoints[i].transform.position, Quaternion.Euler(0f, _rotations[Random.Range(0, _rotations.Length)], 0), _spawnPoints[i]);
                }
            }
        }
    }
}
