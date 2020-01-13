using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;

public class GameManager : MonoBehaviour
{
    //GameManagerVariables
    public static GameManager _gm;

    //////////////////

    public KeyCode _startGame;

    [SerializeField]
    Animator canvasAnimator;
    [SerializeField]
    public GameObject _player;
    [SerializeField]
    public GameObject _omini;
    [SerializeField]
    public Transform _startSpawnPoint;

    public List<GameObject> _humans = new List<GameObject>();
    public GameObject _spaceShip;

    GameObject[] _spawnPoints;
    int _spawnCounter;
    bool gameStarted;

    //ScoreValue
    public int _humanInScene, _humanPickedUp;

    //Timer
    public float _timer = 10f;
    public bool _gameOver, _timeOver, _playerSpawned;

    public int _min;

    //Paninoo
    public bool _follow;
    public bool _pickedUp;
    public bool _timerStarts;


    //Camere
    public GameObject _cam1, _cam2, _cam3;
    [SerializeField]
    CinemachineVirtualCamera vCam;
    float _counter;
    bool _startCounter;
    private bool _soloUno;

    public bool _teleportSpawn;

    private void Awake()
    {
        if (_gm == null)
        {

            _gm = this;
        }
        else
        {
            Destroy(this);
        }
    }
    //GameManagerEndThings
    void Start()
    {
        PopulateArray();
        StartSpawn();
        StartGame();
    }
    void Update()
    {
        _humanInScene = _humans.Count;
        GameTimer();
        GameManagement();
    }

    //testsheep
    public Transform ClosestOmino(GameObject from)
    {       
        
        var minDistance = float.MaxValue;
        
        Transform humanInst = null;
        for (int i = 0; i <= _humans.Count-1; i++)
        {
            if (_humans[i] != null && _humans[i] != from)
            {
                float dist = Vector3.Distance(_humans[i].transform.position, from.transform.position);

                if (dist < minDistance)
                {
                    minDistance = dist;
                    humanInst = _humans[i].transform;
                }
            }
        }
        return humanInst;
    }

    void GameTimer()
    {
        if (_timerStarts)
        {
            Mathf.Clamp(_timer, 0, float.MaxValue);
            _timer -= Time.deltaTime;

            if (_timer <= 0)
            {
                _timer = 0f;
                _timeOver = true;

                vCam.gameObject.SetActive(false);

            }
        }
    }

    void StartSpawn()
    {
        for (int i = 0; i < _spawnPoints.Length; i++)
        {
            _humans.Add(Instantiate(_omini, _spawnPoints[i].transform.position, _spawnPoints[i].transform.rotation));
            if(i == _spawnPoints.Length - 1)
            {
                StartCoroutine("SpawnOmini");
            }
        }
    }
    void PopulateArray()
    {
       _spawnPoints = GameObject.FindGameObjectsWithTag("SpawnOmini");
    }

    void GameManagement()
    {
        if (Input.GetKeyDown(_startGame) && !gameStarted)
        {
            gameStarted = true;
            _cam1.SetActive(false);
            _cam2.SetActive(false);
            _cam3.SetActive(false);
            _spaceShip.GetComponent<Animator>().SetTrigger("SkipStart");
            vCam.gameObject.SetActive(true);
            SpawnPlayer();
        }
        else if (Input.anyKey && !Input.GetKey(_startGame) && !gameStarted)
        {
            gameStarted = true;
            _cam1.SetActive(false);
            _startCounter = true;
            _spaceShip.SetActive(true);
            _spaceShip.GetComponent<Animator>().SetBool("StartGame", true);
            canvasAnimator.SetTrigger("StartGame");
        }
        if (_startCounter && !_soloUno)
        {
            _counter += Time.deltaTime;
            if(_counter>= 9)
            {
                _cam2.SetActive(false);
                _cam3.SetActive(true);
                _teleportSpawn = true;
                if(_counter >= 15)
                {
                    _soloUno = true;
                    Time.timeScale = 0;
                    _startCounter = false;
                    _playerSpawned = true;
                }
            }
        }
        if(_playerSpawned && Input.GetKeyDown(_startGame) && Time.timeScale == 0)
        {
            _cam3.SetActive(false);
            _playerSpawned = false;
            
            SpawnPlayer();
        }
    }

    void SpawnPlayer()
    {
        var playerInstance = Instantiate(_player, _startSpawnPoint.position, _startSpawnPoint.rotation);
        vCam.Follow = playerInstance.transform;
        vCam.LookAt = playerInstance.transform.GetChild(0);
        _timerStarts = true;
        Time.timeScale = 1;
    }
    void StartGame()
    {
        _cam1.SetActive(true);
    }

    IEnumerator SpawnOmini()
    {
        yield return new WaitForSeconds(15);
        if (_spawnCounter >= 3)
        {
            for (int i = 0; i < _spawnPoints.Length; i++)
            {
                _humans.Add(Instantiate(_omini, _spawnPoints[i].transform.position, _spawnPoints[i].transform.rotation));
                if (i == _spawnPoints.Length -1)
                {
                    _spawnCounter = 0;
                    StartCoroutine("SpawnOmini");
                }
            }
        }else if (_spawnCounter < 3)
        {
            _humans.Add(Instantiate(_omini, _spawnPoints[Random.Range(0, _spawnPoints.Length)].transform.position, _spawnPoints[Random.Range(0, _spawnPoints.Length)].transform.rotation));
            _spawnCounter++;
            StartCoroutine("SpawnOmini");
        }
    }
    public void ScoreCounter()
    {
        _humanPickedUp++;
    }
}
