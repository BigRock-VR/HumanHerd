using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class SheepMovement : MonoBehaviour
{
    private NavMeshAgent _agent;

    public GameObject _player;

    public float _enemyDistanceRun = 7.0f;
    public float _enemyCriticDistance = 5.0f;
    public float _distance;

    //Variabili GiroACazzo
    GameObject[] _killerBuildings;
    Transform _destination;
    float _counter;
    int _onlyOne;
    public float _multiplier = 1f;
    private bool _coroutine;

    //Variabili Panino
    List<GameObject> Panino = new List<GameObject>();


    // Start is called before the first frame update
    void Start()
    {
        _player = GameObject.FindGameObjectWithTag("Player");
        _agent = GetComponent<NavMeshAgent>();
        PopulateArray();
    }

    // Update is called once per frame
    void Update()
    {
        Movement();
        GiroAcazzo();
    }

    private void Movement()
    {
        if(_player == null)
        {
            _player = GameObject.FindGameObjectWithTag("Player");
        }
        
        if (_player != null)
        {
            _distance = Vector3.Distance(transform.position, _player.transform.position);

            //RunAWAY
            if (_distance < _enemyDistanceRun && !GameManager._gm._follow)
            {
                if (_agent.enabled == true)
                {
                    _counter = 0;
                    StopAllCoroutines();
                    if (_distance < _enemyCriticDistance)
                    {
                        _agent.speed = _player.GetComponent<PlayerController>()._movSpeed * 2f;
                        _agent.acceleration = 15f;
                    }
                    if (_distance > _enemyCriticDistance)
                    {
                        _agent.speed = _player.GetComponent<PlayerController>()._movSpeed;
                        _agent.acceleration = 7f;
                    }
                    Vector3 dirToPlayer = transform.position - _player.transform.position;
                    Vector3 newPos = transform.position + dirToPlayer;
                    _agent.SetDestination(newPos);
                }
            }
            if (_distance < _enemyDistanceRun && GameManager._gm._follow)
            {
                if (_agent.enabled == true)
                {
                    _counter = 0;
                    StopAllCoroutines();

                    _agent.speed = _player.GetComponent<PlayerController>()._movSpeed * 2f;
                    _agent.acceleration = 15f;

                    Vector3 newPos = _player.transform.position;
                    _agent.SetDestination(newPos);

                }
            }
        }
    }

    private void GiroAcazzo()
    {
        if (GetComponent<Human_ArmMovement>()._moveSpeed == 0 && _agent.enabled)
        {
            _counter += Time.deltaTime * _multiplier;
            if (_counter >= 5)
            {
                if (Panino.Count == 0)
                {
                    float y = float.MaxValue;
                    for (int i = 0; i < _killerBuildings.Length; i++)
                    {
                        var x = Vector3.Distance(transform.position, _killerBuildings[i].transform.position);
                        if (x < y)
                        {
                            y = x;
                            _destination = _killerBuildings[i].transform;
                        }
                    }
                    _agent.SetDestination(_destination.position);
                }
                else
                {
                    _destination = Panino[0].transform;
                    _agent.SetDestination(_destination.position);
                }
            }
            else if (GetComponent<Human_ArmMovement>()._moveSpeed != 0)
            {
                _counter = 0;
            }
        }
    }

    private void PopulateArray()
    {
        _killerBuildings = GameObject.FindGameObjectsWithTag("KillPoint");
    }

    IEnumerator DeathTime()
    {
        if (GameManager._gm._timerStarts)
        {
            yield return new WaitForSeconds(15);
            GameManager._gm._humans.RemoveAt(0);
            _coroutine = false;
            Destroy(gameObject);
        }
        else
        {
            _coroutine = false;
            yield return null;
        }
    }
    private void OnTriggerStay(Collider other)
    {
        if (other.CompareTag("Beacon"))
        {
            Vector3 newPos = other.gameObject.transform.localPosition;
            if (_agent.enabled)
            {
                _agent.SetDestination(newPos);
            }
        }
        if (other.CompareTag("KillPoint") && !_coroutine)
        {
            StartCoroutine("DeathTime");
            _coroutine = true;
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("SpaceShip") && _onlyOne == 0)
        {
            transform.GetChild(3).gameObject.SetActive(false);
            gameObject.GetComponent<CapsuleCollider>().isTrigger = true;
            _onlyOne++;
        }
    }
}
