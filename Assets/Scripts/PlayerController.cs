using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;

public class PlayerController : MonoBehaviour
{
    private float _vMove, _hMove;

    [SerializeField]
    public float _movSpeed = 8f;
    [SerializeField]
    private float _rotSpeed = 150f;
    [SerializeField]
    public float _runInertiaMultiplier = 2f;
    [SerializeField]
    public float _movSpeedMultiplier = 0.2f;
    [SerializeField]
    private float maxSpeed = 20;

    //Inputs Variables
    public KeyCode _pickUp;
    public KeyCode _drop;

    public KeyCode _sprint;
    private bool _sprintBool;
    private bool _inside;
    private bool _picked;
    private bool isRunning;

    //Panino
    private int _powerUpType;
    private float _paninoTimer;
    public GameObject _powerUpComponent;
    
    private GameObject[] _powerUps;

    //Sprint
    public float _counter;
    public float _timeMultiplier;
    public bool _canRun = true;
    private Rigidbody rb;

    //AirBlobVariables
    private float _lerpFly;
    private bool _direction;
    public float _blobMultiplier = 1f;

    //RotationBySpeedVariables
    private float _lerpRot;

    //DeathVariables
    float _lerpMultiplier = 0.05f;
    float _lerpPos;
    public GameObject _spaceShip;




    // Start is called before the first frame update
    void Start()
    {
        rb = transform.GetComponent<Rigidbody>();
        _powerUps = new GameObject[2];
        _spaceShip = GameObject.FindGameObjectWithTag("SpaceShip");
        PopulateArray();
    }

    // Update is called once per frame
    void Update()
    {
        if (!GameManager._gm._gameOver)
        {
            Movement();
            Flying();
        }
        BoolSetting();
        PaninoPicked();
        GameOver();
    }

    private void Movement()
    {
        _hMove = Input.GetAxis("Horizontal");
        _vMove = Input.GetAxis("Vertical");

        //transform.Rotate(0f, _hMove * _rotSpeed * Time.deltaTime, 0f);
        //transform.Translate(0f, 0f, _vMove * _movSpeed * _movSpeedMultiplier * Time.deltaTime);


        if(_hMove != 0)
        {
            transform.Translate(Vector3.right * _hMove * _movSpeed / 100);
        }
        //Sprint inertia
        if(_vMove != 0)
        {
            var dir = transform.TransformDirection(Vector3.forward);
            float modifier;

            if(!isRunning)
            {
                modifier = _movSpeedMultiplier;
            }
            else
            {
                modifier = _runInertiaMultiplier;
            }

            rb.AddForce(dir * _vMove * _movSpeed / modifier, ForceMode.Impulse);
        }
        //Character AIM at mouse
        int mask = ~(1 << 11);
        Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out RaycastHit hit, Mathf.Infinity, mask);
        transform.LookAt(hit.point);



        if (_sprintBool && _canRun && _vMove !=0 )
        {
            isRunning = true;

            if(rb.velocity.magnitude <= maxSpeed)
            {
                
                _counter += Time.deltaTime * _timeMultiplier;
                _movSpeed += 0.08f;

                //_lerpRot = _counter.Remap(0f, 3f, 0f, 1f);
                //var x = Mathf.Lerp(0, 40, _lerpRot);
                //transform.GetChild(0).transform.localRotation = Quaternion.Euler (x, transform.rotation.y, transform.rotation.z);

                if (_counter >= 3f)
                {
                    _canRun = false;
                }
            }
        }
        if (!_sprintBool || !_canRun || _vMove == 0)
        {
            isRunning = false;

                _counter -= Time.deltaTime * _timeMultiplier;
                _movSpeed -= 0.08f;

                if (_counter > 0)
                {
                    //_lerpRot = _counter.Remap(0f, 3f, 0f, 1f);
                    //var x = Mathf.Lerp(0, 40, _lerpRot);
                    //transform.GetChild(0).transform.localRotation = Quaternion.Euler(x, transform.rotation.y, transform.rotation.z);
                }
                if (_counter <= 0f)
                {
                    _movSpeed = 5f;
                    _counter = 0f;
                    _canRun = true;
                }
            
        }
    }

    void Flying()
    {
        if (!_direction)
        {
            _lerpFly += Time.deltaTime * _blobMultiplier;
            if (_lerpFly >= 1f)
            {
                _direction = true;
            }
        }
        if (_direction)
        {
            _lerpFly -= Time.deltaTime * _blobMultiplier;
            if (_lerpFly <= 0f)
            {
                _direction = false;
            }
        }
        var y = Mathf.Lerp(2f, 3f, _lerpFly);
        transform.position = Vector3.Lerp (transform.position, new Vector3(transform.position.x, y, transform.position.z), _lerpFly);
    }

    void PopulateArray()
    {
        for (int i = 0; i < _powerUps.Length; i++)
        {
            _powerUps[i] = _powerUpComponent.transform.GetChild(i).gameObject;
        }
        
    }
    private void BoolSetting()
    {
        if (Input.GetKeyDown(_sprint))
        {
            _sprintBool = true;
        }
        if (Input.GetKeyUp(_sprint))
        {
            _sprintBool = false;
        }

    }
    private void PaninoPicked()
    {
        if (GameManager._gm._follow && _powerUpType == 0)
        {
            _powerUps[0].SetActive(true);
            _paninoTimer += Time.deltaTime;

            if(_paninoTimer >= 10)
            {
                _powerUps[0].SetActive(false);
                _paninoTimer = 0f;
                GameManager._gm._follow = false;
            }
        }if (GameManager._gm._follow && _powerUpType == 1)
        {

            _powerUps[1].SetActive(true);
            _paninoTimer += Time.deltaTime;

            if(_paninoTimer >= 10)
            {
                _powerUps[1].SetActive(false);
                _paninoTimer = 0f;
                GameManager._gm._follow = false;
            }
        }
    }

    void GameOver()
    {
        if (GameManager._gm._timeOver && !_inside)
        {
            gameObject.transform.GetChild(2).gameObject.SetActive(false);
            GameManager._gm._gameOver = true;
        }
        if (GameManager._gm._timeOver && _inside)
        {
            _lerpPos += Time.deltaTime * _lerpMultiplier;
            transform.position = Vector3.Lerp(transform.position, new Vector3(_spaceShip.transform.position.x, _spaceShip.transform.position.y, _spaceShip.transform.position.z - 0.5f), _lerpPos);
            if (_lerpPos >= 0.3f)
            {
                gameObject.transform.GetChild(2).gameObject.SetActive(false);
                GameManager._gm._gameOver = true;
            }
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Tornado"))
        {
            transform.SetParent(other.transform);
            GameManager._gm._gameOver = true;
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if (other.CompareTag("Panino"))
        {
            GameManager._gm._pickedUp = true;
            _powerUpType = 0;
        }
        if (other.CompareTag("Bibita"))
        {
            GameManager._gm._pickedUp = true;
            _powerUpType = 1;

        }

        if (other.CompareTag("Tornado"))
        {
            transform.SetParent(other.transform);

            _lerpPos += Time.deltaTime * _lerpMultiplier;
            transform.localPosition = Vector3.Lerp(transform.localPosition, new Vector3(0f, 0f, 0f), _lerpPos);
            if (_lerpPos >= 0.3f)
            {
                gameObject.transform.GetChild(2).gameObject.SetActive(false);
            }
        }

        if (other.CompareTag("SpaceShip"))
        {
            _inside = true;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("SpaceShip"))
        {
            _inside = false;
        }
    }
}
